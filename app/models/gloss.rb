class Gloss < ActiveRecord::Base
  belongs_to :sense
  validates_presence_of :gloss
  belongs_to :language
  
  scope :attesting, lambda {|parsables, type|
    joins(HASH_MAP_TO_PARSE).where({ :parses => { :parsable_id => parsables, :parsable_type => type }})
  }
  
  HASH_MAP_TO_PARSE = { :sense => Sense::HASH_MAP_TO_PARSE }
end
