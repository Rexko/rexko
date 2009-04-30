class PhoneticForm < ActiveRecord::Base
#  has_and_belongs_to_many :headwords # why?
  belongs_to :lexeme
  has_many :orthographs
  has_many :headwords, :through => :orthographs
  
  validates_presence_of :form
end
