class Document
  include DataMapper::Resource

  property :id,       Serial
  property :name,     String

  has_paper_trail :versions => :paper_trail_versions,
                  :on => [:create, :update]
end
