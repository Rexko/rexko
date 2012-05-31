class Subentry < ActiveRecord::Base
  has_many :etymotheses
  has_many :etymologies, :through => :etymotheses
  belongs_to :lexeme
  belongs_to :language
  has_many :senses
  has_many :notes, :as => :annotatable
  validates_presence_of :paradigm
  
  accepts_nested_attributes_for :senses, :notes, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  accepts_nested_attributes_for :etymologies, :allow_destroy => true, :reject_if => proc {|attrs| Etymology.rejectable?(attrs) }
  
  scope :attesting, lambda {|parsables, type|
    { :joins => HASH_MAP_TO_PARSE, 
      :conditions => { :parses => { :parsable_id => parsables, :parsable_type => type }}
    }
  }
  
  HASH_MAP_TO_PARSE = { :senses => Sense::HASH_MAP_TO_PARSE }
  
  # Default to lexeme's language if language not defined.
  def language
  	read_attribute(:language) || lexeme.try(:language)
	end
end
