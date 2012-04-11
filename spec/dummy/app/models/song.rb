# Example from 'Overwriting default accessors' in ActiveRecord::Base.
class Song
  include DataMapper::Resource

  property :id,         Serial
  property :length,     Integer

  has_paper_trail

  # Uses an integer of seconds to hold the length of the song
  def length=(minutes)
    attribute_set(:length, minutes.to_i * 60)
  end

  def length
    attribute_get(:length) / 60
  end
end
