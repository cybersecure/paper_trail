module PaperTrail
  class Config
    include Singleton
    attr_accessor :enabled, :timestamp_field, :version_class
 
    def initialize
      # Indicates whether PaperTrail is on or off.
      @enabled          = true
      @timestamp_field  = :created_at
      @version_class    = nil
    end
  end
end
