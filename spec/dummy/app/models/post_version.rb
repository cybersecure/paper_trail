class PostVersion < PaperTrail::Model::DataMapper::Version
  storage_names[:default] = 'post_versions'
end
