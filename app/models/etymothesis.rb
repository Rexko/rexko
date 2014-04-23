class Etymothesis < ActiveRecord::Base
  belongs_to :etymology
  belongs_to :subentry
  belongs_to :source
  
  accepts_nested_attributes_for :etymology, allow_destroy: true, reject_if: proc {|attrs| Etymology.rejectable?(attrs) }
  accepts_nested_attributes_for :source, allow_destroy: false, reject_if: :all_blank
end
