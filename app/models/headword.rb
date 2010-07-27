class Headword < ActiveRecord::Base
  has_many :orthographs
  has_many :phonetic_forms, :through => :orthographs
  
  accepts_nested_attributes_for :phonetic_forms, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  
  named_scope :unattested, :joins => ['LEFT OUTER JOIN "parses" ON "parses"."parsed_form" = "form"'], :conditions => {:parses => {:parsed_form => nil}}

  belongs_to :lexeme
  delegate :senses, :to => '(lexeme or return nil)'
  belongs_to :language
  validates_presence_of :form
  
  def self.lookup_all_by_parse parse
    self.find_all_by_form(parse.parsed_form)
  end
  
  def self.lookup_by_parse parse
    self.find_by_form(parse.parsed_form)
  end
end
