class Interpretation < ActiveRecord::Base
  belongs_to :parse
  belongs_to :sense
  
  validates_presence_of :sense
  
  HASH_MAP_TO_PARSE = :parse 
end
