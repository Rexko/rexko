class Etymothesis < ActiveRecord::Base
  belongs_to :etymology
  belongs_to :subentry
end
