class Gloss < ActiveRecord::Base
  belongs_to :sense
  validates_presence_of :gloss
  belongs_to :language
  has_many :parses, :as => :parsable, :dependent => :destroy
  accepts_nested_attributes_for :parses, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  
  scope :attesting, lambda {|parsables, type|
    joins(HASH_MAP_TO_PARSE).where({ :parses => { :parsable_id => parsables, :parsable_type => type }})
  }
  
  HASH_MAP_TO_PARSE = { :sense => Sense::HASH_MAP_TO_PARSE }
  
  # Default to the target_language of the lexeme's dictionaries if not defined
  def language
  	read_attribute(:language) || (Language.lang_for(sense.lexeme.dictionaries, :target_language) if sense.try(:lexeme))
	end
	
	# Determine whether we should hit reject_if when something accepts_nested_attributes_for glosses.
	def self.rejectable?(attrs)
	  attrs[:gloss].blank?
	end
end
