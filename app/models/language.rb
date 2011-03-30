class Language < ActiveRecord::Base
  has_many :dictionaries
  has_many :etymologies
  has_many :glosses
  has_many :headwords
  has_many :senses
  has_many :subentries
  
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
    "Unknown language #{id}"
  end
end
