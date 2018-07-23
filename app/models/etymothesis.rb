class Etymothesis < ApplicationRecord
  belongs_to :etymology, optional: true
  belongs_to :subentry, optional: true
  belongs_to :source, optional: true
  
  accepts_nested_attributes_for :etymology, allow_destroy: true, reject_if: proc {|attrs| Etymology.rejectable?(attrs) }
  accepts_nested_attributes_for :source, allow_destroy: false, reject_if: :all_blank
  
  def self.safe_params
    [:id, etymology_attributes: Etymology.safe_params, source_attributes: Source.safe_params]
  end

  # Dissociate the source 
  # when hitting 'delete' from an etymology form
  # instead of deleting it.
  def source_attributes=(attributes)
    if attributes['_destroy']
      self.source_id = nil
    end
  end
end
