class Language < ActiveRecord::Base
  has_many :dictionaries
  has_many :etymologies
  has_many :glosses
  has_many :headwords
  has_many :senses
  has_many :subentries
  
  def to_s
    "%s%s" % [
      default_name,
      (" (#{iso_639_code})" if iso_639_code)
    ]
  end
end
