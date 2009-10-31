class Etymology < ActiveRecord::Base
  has_many :etymotheses
  has_many :subentries, :through => :etymotheses
  belongs_to :language # language of gloss and source_language name
  has_many :notes, :as => :annotatable
  
  accepts_nested_attributes_for :notes, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  
protected 
  def validate
    if [etymon, source_language, gloss].all?(&:blank?)
      errors.add_to_base("At least one attribute of the etymology must be specified")
    end
  end
end
