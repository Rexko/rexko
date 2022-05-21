# frozen_string_literal: true

class Gloss < ApplicationRecord
  attribute :gloss

  belongs_to :sense, optional: true
  validate :any_gloss_present?
  belongs_to :language, optional: true
  has_many :parses, as: :parsable, dependent: :destroy
  accepts_nested_attributes_for :parses, allow_destroy: true, reject_if: proc { |attributes|
                                                                           attributes.all? do |_k, v|
                                                                             v.blank?
                                                                           end
                                                                         }
  translates :gloss, fallbacks_for_empty_translations: true
  globalize_accessors locales: (Language.defined_language_codes | [I18n.default_locale])

  default_scope { includes(:translations) }

  scope :attesting, lambda { |parsables, type|
    joins(HASH_MAP_TO_PARSE).where({ parses: { parsable_id: parsables, parsable_type: type } })
  }

  HASH_MAP_TO_PARSE = { sense: Sense::HASH_MAP_TO_PARSE }.freeze

  # Default to the target_language of the lexeme's dictionaries if not defined
  before_save :set_defaults

  def self.safe_params
    [:gloss, *Gloss.globalize_attribute_names]
  end

  # Default to lexeme's language if language not defined.
  def set_defaults
    default_language = (if sense.try(:lexeme)
                          Language.lang_for(sense.lexeme.dictionaries,
                                            :target_language)
                        end) || Language.new

    self.language ||= default_language
  end

  # Determine whether we should hit reject_if when something accepts_nested_attributes_for glosses.
  protected

  def any_gloss_present?
    # attrs[:gloss].blank? # before we had i18n
    # attrs = attrs.attributes if attrs.is_a? Gloss
    errors.add(:gloss, I18n.t('errors.messages.blank')) unless translations.any? { |xlat| xlat.gloss.present? }
  end
end
