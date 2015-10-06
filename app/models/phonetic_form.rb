class PhoneticForm < ActiveRecord::Base
#  has_and_belongs_to_many :headwords # why?
  has_many :orthographs
  has_many :headwords, :through => :orthographs
  has_many :notes, as: :annotatable
  translates :form, :fallbacks_for_empty_translations => true
  globalize_accessors :locales => (Language.defined_language_codes | [I18n.default_locale])
  accepts_nested_attributes_for :notes, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
 
  validate :any_form_present?
  
  protected
  def any_form_present?
    if globalize_attribute_names.select {|k,v| k.to_s.start_with?("form")}.all? {|v| v.blank? }
      errors.add(:form, I18n.t('errors.messages.blank'))
    end
  end
end
