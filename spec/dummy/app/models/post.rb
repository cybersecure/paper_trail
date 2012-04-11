class Post
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String
  property :content,    String

  has_paper_trail #:class_name => "PostVersion"
end
