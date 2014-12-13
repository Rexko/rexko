class PhoneticForm < ActiveRecord::Base
#  has_and_belongs_to_many :headwords # why?
  has_many :orthographs
  has_many :headwords, :through => :orthographs
  translates :form
 
  validates_presence_of :form
end
