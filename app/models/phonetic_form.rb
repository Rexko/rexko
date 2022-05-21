# frozen_string_literal: true

class PhoneticForm < ApplicationRecord
  attribute :form

  #  has_and_belongs_to_many :headwords # why?
  has_many :orthographs
  has_many :headwords, through: :orthographs
  has_many :notes, as: :annotatable
  translates :form, fallbacks_for_empty_translations: true
  globalize_accessors locales: (Language.defined_language_codes | [I18n.default_locale])
  accepts_nested_attributes_for :notes, allow_destroy: true, reject_if: :all_blank

  validate :any_form_present?

  INCLUDE_TREE = { phonetic_forms: :translations }.freeze

  def self.safe_params
    :form
  end

  # Return an array of all defined phonetic forms
  def phonetic_forms
    translations.inject([]) do |memo, obj|
      obj.form? ? memo | [obj.form] : memo
    end
  end

  protected

  def any_form_present?
    if globalize_attribute_names.select { |k, _v| k.to_s.start_with?('form') }.all?(&:blank?)
      errors.add(:form, I18n.t('errors.messages.blank'))
    end
  end
end
