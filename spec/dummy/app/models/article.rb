class Article
  include DataMapper::Resource

  property :id,           Serial
  property :title,        String
  property :content,      String
  property :abstract,     String
  property :file_upload,  String

  has_paper_trail :ignore => :title,
                  :only => [:content],
                  :skip => [:file_upload],
                  :meta   => {:answer => 42,
                              :action => :action_data_provider_method,
                              :question => Proc.new { "31 + 11 = #{31 + 11}" },
                              :article_id => Proc.new { |article| article.id } }

  def action_data_provider_method
    self.id.to_s
  end
end
