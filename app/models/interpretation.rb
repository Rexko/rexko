class Interpretation < ActiveRecord::Base
  belongs_to :parse
  belongs_to :sense
  
  accepts_nested_attributes_for :sense, :reject_if => :all_blank
  
  HASH_MAP_TO_PARSE = :parse 
end
