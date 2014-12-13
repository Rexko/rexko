class Headword < ActiveRecord::Base
  has_many :orthographs
  has_many :phonetic_forms, :through => :orthographs
  has_many :notes, as: :annotatable
  translates :form
  
  accepts_nested_attributes_for :phonetic_forms, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  accepts_nested_attributes_for :notes, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  
  scope :unattested, joins(['LEFT OUTER JOIN "parses" ON "parses"."parsed_form" = "form"']).where({:parses => {:parsed_form => nil}})

  belongs_to :lexeme
  delegate :senses, :to => '(lexeme or return nil)'
  belongs_to :language
  validates_presence_of :form
  
  before_save :set_defaults
  
  DESCRIPTIVE = 1
  PRESCRIPTIVE = 2

  after_initialize do |hw|
    # Most likely default: assume the most acceptable forms are being entered.
    self.acceptance ||= DESCRIPTIVE | PRESCRIPTIVE
  end

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
  
  # Given 1 (true) or 0 (false), set the headword's descriptively-correct status
  def descriptively_ok=(status)
    self.acceptance = (acceptance & PRESCRIPTIVE) | (status.to_i * DESCRIPTIVE)
  end
  
  # Returns whether the headword has been marked as prescriptively correct
  def prescriptively_ok?
    acceptance & PRESCRIPTIVE == PRESCRIPTIVE
  end
  
  # Given 1 (true) or 0 (false), set the headword's prescriptively-correct status
  def prescriptively_ok=(status)
    self.acceptance = (acceptance & DESCRIPTIVE) | (status.to_i * PRESCRIPTIVE) 
  end
end
