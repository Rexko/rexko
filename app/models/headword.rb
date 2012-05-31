class Headword < ActiveRecord::Base
  has_many :orthographs
  has_many :phonetic_forms, :through => :orthographs
  
  accepts_nested_attributes_for :phonetic_forms, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  
  scope :unattested, joins(['LEFT OUTER JOIN "parses" ON "parses"."parsed_form" = "form"']).where({:parses => {:parsed_form => nil}})

  belongs_to :lexeme
  delegate :senses, :to => '(lexeme or return nil)'
  belongs_to :language
  validates_presence_of :form
  
  before_save :set_defaults
  
  def set_defaults
  	default_language = lexeme.try(:language) || Language.new
 
  	self.language ||= default_language
	end
  
  def self.lookup_all_by_parse parse
    self.find_all_by_form(parse.parsed_form)
  end
  
  def self.lookup_by_parse parse
    self.find_by_form(parse.parsed_form)
  end
  
  # Default to lexeme's language if language not defined.
  def language
  	read_attribute(:language) || lexeme.try(:language)
	end
end
