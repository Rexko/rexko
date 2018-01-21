class Interpretation < ActiveRecord::Base
  belongs_to :parse
  belongs_to :sense
  
  accepts_nested_attributes_for :sense, :reject_if => :all_blank
  
  attr_accessible :sense_attributes, :sense_id, :sense
  
  # ARel conditions for whether this interpretation is linking a parse to a sense
  NOT_INTERPRETING = arel_table[:parse_id].eq(nil).or(arel_table[:sense_id].eq(nil))
  
  HASH_MAP_TO_PARSE = :parse 
end
