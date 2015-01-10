class Sense < ActiveRecord::Base
  belongs_to :subentry
  delegate :lexeme, :to => '(subentry or return nil)' 
  belongs_to :language
  has_many :glosses
  has_many :interpretations
  has_many :parses, :through => :interpretations
  has_many :notes, :as => :annotatable
  validate :validate_sufficient_data
  translates :definition, :fallbacks_for_empty_translations => true
  globalize_accessors :locales => (Language.all.collect(&:iso_639_code) | [I18n.default_locale])
  
  accepts_nested_attributes_for :parses, :notes, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  accepts_nested_attributes_for :glosses, :allow_destroy => true, :reject_if => proc {|attrs| Gloss.rejectable?(attrs) }
  
  HASH_MAP_TO_PARSE = { :interpretations => Interpretation::HASH_MAP_TO_PARSE }
  
  def self.lookup_all_by_headword(form)
    swapform = form.dup
    swapform[0,1] = swapform[0,1].swapcase
    
    Sense.find(:all, :joins => [{ :subentry => { :lexeme => :headwords} } ], :conditions => ["headwords.form = ? OR headwords.form = ?", form, swapform])
  end
  
  before_save :set_defaults
  
  # Default to lexeme's language if language not defined.
  def set_defaults
  	default_language = lexeme.try(:language) || Language.new
 
  	self.language ||= default_language
	end
  
protected
  def validate_sufficient_data
    if definition.blank? && glosses.empty?
      errors.add_to_base("Definition or gloss must be supplied for a sense") 
    end
  end
end
