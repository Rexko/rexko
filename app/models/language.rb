class Language < ActiveRecord::Base
  has_many :dictionaries
  has_many :etymologies
  has_many :glosses
  has_many :headwords
  has_many :senses
  has_many :subentries
  
  MULTIPLE_LANGUAGES = new(:default_name => 'Multiple languages', :iso_639_code => 'mul')
  UNDETERMINED = new(:default_name => 'Undetermined', :iso_639_code => 'und')
  NO_LINGUISTIC_CONTENT = new(:default_name => 'No linguistic content', :iso_639_code => 'zxx')
  UNKNOWN_LANGUAGE = "Unknown language %d"
  
  # Return the name of a language plus its ISO code if present.
  def to_s
    "%s%s" % [
      default_name,
      (" (#{iso_639_code})" if iso_639_code.present?)
    ]
  end
  
  # Return the best short name of the language
  def name
    (default_name if default_name.present?) || 
    (iso_639_code if iso_639_code.present?) || 
    UNKNOWN_LANGUAGE % id
  end
  
  # lang_for: Returns the Language used in the element or array.
  #
  # Will return: 
  # * 'und' (ISO 639: 'undetermined') if no languages are found for
  #   any of the content
  # * 'mul' (ISO 639: 'multiple languages') if more than one 
  #   language is found in the array's content
  # * the Language associated to the content, if they all use the same
  def self.lang_for content
  	[*content].inject(nil) do |memo, elem| 
      lang = elem ? elem.language || UNDETERMINED : NO_LINGUISTIC_CONTENT
      memo ? if lang == memo then memo else break MULTIPLE_LANGUAGES end : lang
    end || UNDETERMINED
	end
  
  def self.code_for content, subtags = {}
  	self.lang_for(content).iso_639_code.tap do |code|
    	code += '-' + subtags[:variant] unless subtags[:variant].blank?
    end
	end
end
