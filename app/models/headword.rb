class Headword < ActiveRecord::Base
  has_many :orthographs
  has_many :phonetic_forms, :through => :orthographs
  has_many :notes, as: :annotatable
  
  accepts_nested_attributes_for :phonetic_forms, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  
  scope :unattested, joins(['LEFT OUTER JOIN "parses" ON "parses"."parsed_form" = "form"']).where({:parses => {:parsed_form => nil}})

  belongs_to :lexeme
  delegate :senses, :to => '(lexeme or return nil)'
  belongs_to :language
  validates_presence_of :form
  
  before_save :set_defaults
  
  DESCRIPTIVE = 1
  PRESCRIPTIVE = 2

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
  
  # Returns whether the headword has been marked as descriptively correct
  def descriptively_ok?
    acceptance & DESCRIPTIVE == DESCRIPTIVE
  end
  
  # Returns whether the headword has been marked as prescriptively correct
  def prescriptively_ok?
    acceptance & PRESCRIPTIVE == PRESCRIPTIVE
  end
end
