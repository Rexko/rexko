# frozen_string_literal: true

class Sense < ApplicationRecord
  attribute :definition

  belongs_to :subentry, optional: true
  delegate :lexeme, to: '(subentry or return nil)'
  belongs_to :language, optional: true
  has_many :glosses
  has_many :interpretations
  has_many :parses, through: :interpretations
  has_many :notes, as: :annotatable
  validate :validate_sufficient_data
  translates :definition, fallbacks_for_empty_translations: true
  globalize_accessors locales: (Language.defined_language_codes | [I18n.default_locale])

  accepts_nested_attributes_for :parses, :notes, allow_destroy: true, reject_if: proc { |attributes|
                                                                                   attributes.all? do |_k, v|
                                                                                     v.blank?
                                                                                   end
                                                                                 }
  accepts_nested_attributes_for :glosses, allow_destroy: true, reject_if: proc { |attributes|
                                                                            attributes.select do |k, _v|
                                                                              k.start_with?('gloss')
                                                                            end.none? do |_k, v|
                                                                              v.present?
                                                                            end
                                                                          }

  HASH_MAP_TO_PARSE = { interpretations: Interpretation::HASH_MAP_TO_PARSE }.freeze
  INCLUDE_TREE = { senses: %i[glosses notes language translations] }.freeze

  def self.safe_params
    [:id, :_destroy, :definition, :subentry_id, *Sense.globalize_attribute_names, {
      glosses_attributes: Gloss.safe_params
    }]
  end

  # Returns all senses for lexemes with a headword matching +form+, insensitive to the case of the first letter.
  def self.lookup_all_by_headword(form)
    swapform = form.dup
    swapform[0, 1] = swapform[0, 1].swapcase

    Sense.joins([{ subentry: { lexeme: { headwords: [:translations] } } }]).where([
                                                                                    'headword_translations.form = ? OR headword_translations.form = ?', form, swapform
                                                                                  ])
  end

  def self.lookup_all_by_parses_of(locus)
    Sense.select('DISTINCT "senses".*, "headword_translations"."form" AS hw_form').joins(['INNER JOIN "subentries" ON "subentries".id = "senses".subentry_id INNER JOIN "lexemes" ON "lexemes".id = "subentries".lexeme_id INNER JOIN "headwords" ON "headwords".lexeme_id = "lexemes".id INNER JOIN "headword_translations" ON "headword_translations"."headword_id" = "headwords".id INNER JOIN "parses" ON "parses"."parsed_form" = "headword_translations"."form" INNER JOIN "attestations" ON ("parses"."parsable_id" = "attestations"."id" AND "parses"."parsable_type" = \'Attestation\')']).where(['"attestations"."locus_id" = ?', locus.id]).includes(
      { subentry: [{ lexeme: :dictionaries }, :translations] }, :translations
    )
  end

  before_save :set_defaults

  # Default to lexeme's language if language not defined.
  def set_defaults
    default_language = lexeme.try(:language) || Language.new

    self.language ||= default_language
  end

  protected

  # Check to see if either a definition or a gloss has been supplied.
  def validate_sufficient_data
    if globalize_attribute_names.select do |k, _v|
         k.to_s.start_with?('definition')
       end.all?(&:blank?) && glosses.empty?
      errors[:base] << 'Definition or gloss must be supplied for a sense'
    end
  end
end
