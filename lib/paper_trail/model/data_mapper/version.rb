require 'dm-core'
require 'dm-validations'
require 'dm-rails'

module PaperTrail::Model::DataMapper
  class Version
    include ::DataMapper::Resource
    include ::DataMapper::MassAssignmentSecurity
  
    property :id,               Serial
  
    property :item_id,          Integer,  :required => true
    property :item_type,        String,   :required => true
    property :event,            String,   :required => true
    property :whodunnit,        String,   :required => true
    property :object,           Text
    property :object_changes,   Text
    
    property :created_at,       DateTime

    attr_accessible :item_type, :item_id, :event, :whodunnit, :object, :object_changes

    def self.with_item_keys(item_type, item_id)
      all(:item_type => item_type, :item_id => item_id)
    end

    def self.creates
      all(:event => 'create')
    end

    def self.updates
      all(:event => 'update')
    end

    def self.destroys
      all(:event => 'destroy')
    end
  
    def subsequent(version)
      all(self.key.gt => version, :order => self.key.asc)
    end

    def preceding(version)
      all(self.key.lt => version, :order => self.key.desc)
    end

    def following(timestamp)
      all(PaperTrail.timestamp_field.gt => timestamp, :order => [PaperTrail.timestamp_field.asc, self.key.asc])
    end

    def between(start_time,end_time)
      all(PaperTrail.timestamp_field.gt => start_time, PaperTrail.timestamp_field.lt => end_time, :order => [PaperTrail.timestamp_field.asc, self.key.asc])
    end

    # Restore the item from this version.
    #
    # This will automatically restore all :has_one associations as they were "at the time",
    # if they are also being versioned by PaperTrail.  NOTE: this isn't always guaranteed
    # to work so you can either change the lookback period (from the default 3 seconds) or
    # opt out.
    #
    # Options:
    # +:has_one+   set to `false` to opt out of has_one reification.
    #              set to a float to change the lookback time (check whether your db supports
    #              sub-second datetimes if you want them).
    def reify(options = {})
      options[:has_one] = 3 if options[:has_one] == true
      options.reverse_merge! :has_one => false
      
      unless object.nil?
        attrs = YAML::load object
        
        klass = item_type.constantize
        model = klass.new

        attrs.each do |k, v|
          if model.respond_to?("#{k}=")
            model.send :attribute_set, k.to_sym, v
          else
            logger.warn "Attribute #{k} does not exist on #{item_type} (Version id: #{id})."
          end
        end

        unless options[:has_one] == false
          reify_has_ones model, options[:has_one]
        end

        model
      end
    end

    # Returns what changed in this version of the item.  Cf. `ActiveModel::Dirty#changes`.
    # Returns nil if your `versions` table does not have an `object_changes` text column.
    def changeset
      if self.class.column_names.include? 'object_changes'
        if changes = object_changes
          HashWithIndifferentAccess[YAML::load(changes)]
        else
          {}
        end
      end
    end

    # Returns who put the item into the state stored in this version.
    def originator
      previous.try :whodunnit
    end

    # Returns who changed the item from the state it had in this version.
    # This is an alias for `whodunnit`.
    def terminator
      whodunnit
    end

    def sibling_versions
      self.class.with_item_keys(item_type, item_id)
    end

    def next
      sibling_versions.subsequent(self).first
    end

    def previous
      sibling_versions.preceding(self).first
    end

    def index
      id_column = self.class.key.to_sym
      sibling_versions.select(id_column).order("#{id_column} ASC").map(&id_column).index(self.send(id_column))
    end

    private

    # Restore the `model`'s has_one associations as they were when this version was
    # superseded by the next (because that's what the user was looking at when they
    # made the change).
    #
    # The `lookback` sets how many seconds before the model's change we go.
    def reify_has_ones(model, lookback)
      model.class.reflect_on_all_associations(:has_one).each do |assoc|
        child = model.send assoc.name
        if child.respond_to? :version_at
          # N.B. we use version of the child as it was `lookback` seconds before the parent was updated.
          # Ideally we want the version of the child as it was just before the parent was updated...
          # but until PaperTrail knows which updates are "together" (e.g. parent and child being
          # updated on the same form), it's impossible to tell when the overall update started;
          # and therefore impossible to know when "just before" was.
          if (child_as_it_was = child.version_at(send(PaperTrail.timestamp_field) - lookback.seconds))
            child_as_it_was.attributes.each do |k,v|
              model.send(assoc.name).send :write_attribute, k.to_sym, v rescue nil
            end
          else
            model.send "#{assoc.name}=", nil
          end
        end
      end
    end

  end
end
