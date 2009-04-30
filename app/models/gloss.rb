class Gloss < ActiveRecord::Base
  belongs_to :sense
  validates_presence_of :gloss
  belongs_to :language
end
