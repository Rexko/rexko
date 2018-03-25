class Subentry < ActiveRecord::Base
  has_many :etymotheses
  has_many :etymologies, :through => :etymotheses
  belongs_to :lexeme
  belongs_to :language
  has_many :senses
  has_many :notes, :as => :annotatable
  validate :any_paradigm_present?
  translates :paradigm, :part_of_speech, :fallbacks_for_empty_translations => true
  globalize_accessors :locales => (Language.defined_language_codes | [I18n.default_locale])
  
  accepts_nested_attributes_for :senses, :notes, :etymotheses, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  accepts_nested_attributes_for :etymologies, :allow_destroy => true, :reject_if => proc {|attrs| Etymology.rejectable?(attrs) }
  
  def self.safe_params
    [:id, :_destroy, :paradigm, Subentry.globalize_attribute_names, :etymotheses_attributes => Etymothesis.safe_params, :senses_attributes => Sense.safe_params]
  end
  
  scope :attesting, lambda {|parsables, type|
    joins(HASH_MAP_TO_PARSE).where(:parses => { :parsable_id => parsables, :parsable_type => type })
  }
  
  HASH_MAP_TO_PARSE = { :senses => Sense::HASH_MAP_TO_PARSE }
  INCLUDE_TREE = {:subentries => [:translations, Sense::INCLUDE_TREE,  Etymology::INCLUDE_TREE, :notes, :language]}
  
  before_save :set_defaults
  
  # Default to lexeme's language if language not defined.
  def set_defaults
  	default_language = lexeme.try(:language) || Language.new
 
  	self.language ||= default_language
	end
  
  protected
  def any_paradigm_present?
    if globalize_attribute_names.select {|k,v| k.to_s.start_with?("paradigm")}.all? {|v| v.blank? }
      errors.add(:paradigm, I18n.t('errors.messages.blank'))
    end
  end
end
