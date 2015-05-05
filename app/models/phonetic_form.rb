class PhoneticForm < ActiveRecord::Base
#  has_and_belongs_to_many :headwords # why?
  has_many :orthographs
  has_many :headwords, :through => :orthographs
  translates :form, :fallbacks_for_empty_translations => true
  globalize_accessors :locales => (Language.all.collect(&:iso_639_code) | [I18n.default_locale])
 
  validate :any_form_present?
  
  protected
  def any_form_present?
    if globalize_attribute_names.select {|k,v| k.to_s.start_with?("form")}.all? {|v| v.blank? }
      errors.add(:form, I18n.t('errors.messages.blank'))
    end
  end
end
