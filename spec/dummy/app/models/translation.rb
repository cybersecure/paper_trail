class Translation
  include DataMapper::Resource
  
  property :id,             Serial
  property :headline,       String
  property :content,        String
  property :language_code,  String
  property :type,           String
  
  has_paper_trail :if     => Proc.new { |t| t.language_code == 'US' },
                  :unless => Proc.new { |t| t.type == 'DRAFT'       }
end
