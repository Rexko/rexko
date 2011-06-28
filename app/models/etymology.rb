class Etymology < ActiveRecord::Base
  has_many :etymotheses
  has_many :subentries, :through => :etymotheses
  belongs_to :language # language of gloss and source_language name
  has_many :notes, :as => :annotatable
  has_many :parses, :as => :parsable
  belongs_to :next_etymon, :class_name => "Etymology"
  belongs_to :original_language, :class_name => "Language" # language of etymon
  validate :validate_sufficient_data
  
  accepts_nested_attributes_for :notes, :parses, {:allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }}
  accepts_nested_attributes_for :next_etymon, :allow_destroy => true, :reject_if => proc {|attrs| Etymology.rejectable?(attrs) }
  
  def to_s
    [original_language.try(:name), etymon].compact.join " "
  end
  
  # Hash map of this etymon and its parent etyma
  def ancestor_map ignore=[]
    return { self => {} } if ignore.include? self
    
    ignore << self
    parent_etym = primary_parent
    
    selfmap = parent_etym ? { self => parent_etym.ancestor_map(ignore) } : { self => {} }
    next_etymon ? [selfmap, next_etymon.ancestor_map(ignore)] : selfmap
  end
  
  def primary_parent
    prim_sub = Subentry.attesting(self, "Etymology").first
    prim_sub.etymologies.first if prim_sub
  end
  
  def primary_gloss
    gloss.present? ? gloss : Gloss.attesting(self, "Etymology").first.try(:gloss)
  end
  
  # Determine whether the given attribute hash would create an invalid etymology.
  def self.rejectable?(attrs)
  	next_etymon_rejectable = (attrs["next_etymology_attributes"] ? Etymology.rejectable?(attrs["next_etymology_attributes"]) : nil)
  	[next_etymon_rejectable, attrs["etymon"], attrs["original_language"], attrs["gloss"], attrs["notes"]].all?(&:blank?)
  end
  
protected 
  def validate_sufficient_data
    if [etymon, original_language, gloss, notes].all?(&:blank?)
      errors.add(:base, "At least one attribute of the etymology must be specified")
    end
  end
end
