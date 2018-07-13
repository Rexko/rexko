class Headword < ApplicationRecord
  attribute :form

  has_many :orthographs
  has_many :phonetic_forms, :through => :orthographs
  has_many :notes, as: :annotatable
  translates :form, :fallbacks_for_empty_translations => true
  globalize_accessors :locales => (Language.defined_language_codes | [I18n.default_locale])
  
  accepts_nested_attributes_for :phonetic_forms, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  accepts_nested_attributes_for :notes, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  
  scope :unattested, -> { joins(['LEFT OUTER JOIN "parses" ON "parses"."parsed_form" = "form"']).where({:parses => {:parsed_form => nil}}) }

  belongs_to :lexeme, optional: true
  delegate :senses, :to => '(lexeme or return nil)'
  belongs_to :language, optional: true
  validate :any_form_present?
  
  before_save :set_defaults
  
  DESCRIPTIVE = 1
  PRESCRIPTIVE = 2
  INCLUDE_TREE = { :headwords => [PhoneticForm::INCLUDE_TREE, :language, :translations] }

  after_initialize do |hw|
    # Most likely default: assume the most acceptable forms are being entered.
    self.acceptance ||= DESCRIPTIVE | PRESCRIPTIVE
  end

  def self.safe_params
    [:_destroy, :form, :descriptively_ok, :prescriptively_ok, Headword.globalize_attribute_names, :phonetic_forms_attributes => {}, :notes_attributes => Note.safe_params]
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
  
  # Return the orthographic form appropriate to the given locale. 
  # If no locale is given, return the default (current) locale, or the 
  # first translation given. 
  def form loc = nil 
    if loc
      form_translations[loc]
    else
      self[:form] || form_translations.detect(->{[]}) {|k, v| v.present? }[1]
    end
  end
  
  # Return an array of all defined orthographic forms
  def orthographic_forms
    translations.inject([]) do |memo, obj|
      obj.form? ? memo | [obj.form] : memo
    end
  end
  
  # Returns an array containing the forms of the most acceptable headwords
  def self.best_headword_forms(headwords)
    return [] if headwords.empty?

    most_accepted = headwords.max_by {|hw2| hw2.acceptance }.acceptance
    
    forms = headwords.select {|hw| hw.acceptance == most_accepted}.inject([]) do |memo, obj|
      memo | obj.orthographic_forms
    end
  end
  
  # Returns an array containing the phonetic forms of the most acceptable headwords
  def self.best_phonetic_forms(headwords)
    return [] if headwords.empty?
    
    most_accepted = headwords.max_by {|hw2| hw2.acceptance }.acceptance
    
    forms = headwords.select {|hw| hw.acceptance == most_accepted}.inject([]) do |memo, obj|
      memo | obj.phonetic_forms.collect(&:phonetic_forms).flatten
    end
  end
  
  protected
  def any_form_present?
    if globalize_attribute_names.select {|k,v| k.to_s.start_with?("form")}.all? {|v| v.blank? }
      errors.add(:form, I18n.t('errors.messages.blank'))
    end
  end
end
