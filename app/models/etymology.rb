class Etymology < ActiveRecord::Base
  has_many :etymotheses
  has_many :subentries, :through => :etymotheses
  belongs_to :language # language of gloss and source_language name
  has_many :notes, :as => :annotatable
  has_many :parses, :as => :parsable
  belongs_to :next_etymon, :class_name => "Etymology"
  belongs_to :original_language, :class_name => "Language" # language of etymon
  
  accepts_nested_attributes_for :notes, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  accepts_nested_attributes_for :parses, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  accepts_nested_attributes_for :next_etymon, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  
  def primary_gloss
    gloss.present? ? gloss : Gloss.attesting(self, "Etymology").first.try(:gloss)
  end
  
  def self.rejectable?(attrs)
    !new(attrs.delete_if{|key, value| key == "_delete"}).valid?
  end 

protected 
  def validate
    if [etymon, original_language, gloss, notes].all?(&:blank?)
      errors.add_to_base("At least one attribute of the etymology must be specified")
    end
  end
end
