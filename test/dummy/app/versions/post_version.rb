class PostVersion < PaperTrail::Model::ActiveRecord::Version
  self.table_name = 'post_versions'
end
