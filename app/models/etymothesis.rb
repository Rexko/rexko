class Etymothesis < ActiveRecord::Base
  belongs_to :etymology
  belongs_to :subentry
  belongs_to :source
end
