class Etymology < ActiveRecord::Base
  has_many :etymotheses
  has_many :subentries, :through => :etymotheses
  belongs_to :language # language of gloss and source_language name
  has_many :notes, :as => :annotatable
  has_many :parses, :as => :parsable
  belongs_to :next_etymon, :class_name => "Etymology"
  belongs_to :original_language, :class_name => "Language" # language of etymon
  
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
  
  def self.rejectable?(attrs)
    !new(attrs.delete_if{|key, value| key == "_destroy"}).valid?
  end
  
protected 
  def validate
    if [etymon, original_language, gloss, notes].all?(&:blank?)
      errors.add_to_base("At least one attribute of the etymology must be specified")
    end
  end
end
