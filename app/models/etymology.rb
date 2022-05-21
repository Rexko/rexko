class Etymology < ApplicationRecord
  has_many :etymotheses
  has_many :subentries, through: :etymotheses
  has_many :sources, through: :etymotheses
  belongs_to :language # language of gloss and source_language name
  has_many :notes, as: :annotatable
  has_many :parses, as: :parsable, dependent: :destroy
  belongs_to :next_etymon, optional: true, class_name: 'Etymology'
  belongs_to :original_language, optional: true, class_name: 'Language' # language of etymon
  validate :validate_sufficient_data
  translates :gloss
  globalize_accessors locales: (Language.defined_language_codes | [I18n.default_locale])

  accepts_nested_attributes_for :original_language, reject_if: proc { |attributes|
                                                                 attributes.all? do |_k, v|
                                                                   v.blank?
                                                                 end
                                                               }
  accepts_nested_attributes_for :notes, { allow_destroy: true, reject_if: proc { |attributes|
                                                                            attributes.all? do |_k, v|
                                                                              v.blank?
                                                                            end
                                                                          } }
  accepts_nested_attributes_for :parses, allow_destroy: true, reject_if: proc { |attrs| Parse.rejectable?(attrs) }
  accepts_nested_attributes_for :next_etymon, allow_destroy: true, reject_if: proc { |attrs|
                                                                                Etymology.rejectable?(attrs)
                                                                              }

  INCLUDE_TREE = { etymologies: %i[notes translations] }

  def self.safe_params
    [:etymotheses_attributes, :etymon, :next_etymon, { parses_attributes: Parse.safe_params }]
  end

  def to_s
    [original_language.try(:name), etymon].compact.join ' '
  end

  # Hash map of this etymon and its parent etyma
  def ancestor_map(ignore = [])
    if ignore.include? self
      if next_etymon.present? && !ignore.include?(next_etymon)
        return [{ self => {} }, next_etymon.ancestor_map(ignore)]
      else
        return { self => {} }
      end
    end

    ignore << self
    parent_etym = primary_parent

    selfmap = parent_etym ? { self => parent_etym.ancestor_map(ignore) } : { self => {} }
    next_etymon ? [selfmap, next_etymon.ancestor_map(ignore)] : selfmap
  end

  def primary_parent
    prim_sub = Subentry.attesting(self, 'Etymology').first
    prim_sub.etymologies.first if prim_sub
  end

  # Determine whether the given attribute hash would create an invalid etymology.
  def self.rejectable?(attrs)
    next_etymon_rejectable = (attrs['next_etymology_attributes'] ? Etymology.rejectable?(attrs['next_etymology_attributes']) : nil)
    [next_etymon_rejectable, attrs['etymon'], attrs['original_language'], attrs['gloss'],
     attrs['notes_attributes']].all?(&:blank?)
  end

  # Default to multiple (as it usually is)
  # Correct behaviour should be language of dictionaries + language of etyma
  def language
    read_attribute(:language) || Language::MULTIPLE_LANGUAGES
  end

  # Next_etyma do not have subentries themselves.
  # This is ugly.
  def subentries
    # If we have our own subentries, use them.
    own_subentries = Subentry.joins(:etymotheses).where(etymotheses: { etymology_id: id })
    return own_subentries if own_subentries.exists?

    # If we are next etymon of anything else, use that etymon's subentries.
    prev_etymon = Etymology.where(next_etymon_id: id).first
    return prev_etymon.subentries if prev_etymon

    # Default response
    []
  end

  # Assign original language from lexeme form.  Use existing language
  # if 'id' is present, otherwise create a new language with attributes
  def original_language_attributes=(attributes)
    if attributes['id'].present?
      self.original_language = Language.find(attributes['id'])
    else
      assign_nested_attributes_for_one_to_one_association(:original_language, attributes)
    end
  end

  protected

  def validate_sufficient_data
    if [etymon, original_language, gloss, notes].all?(&:blank?)
      errors.add(:base, 'At least one attribute of the etymology must be specified')
    end
  end
end
