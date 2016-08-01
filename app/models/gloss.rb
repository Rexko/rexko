class Gloss < ActiveRecord::Base
  belongs_to :sense
  validate :any_gloss_present?
  belongs_to :language
  has_many :parses, :as => :parsable, :dependent => :destroy
  accepts_nested_attributes_for :parses, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  translates :gloss, :fallbacks_for_empty_translations => true
  globalize_accessors :locales => (Language.defined_language_codes | [I18n.default_locale])  
  
  scope :attesting, lambda {|parsables, type|
    joins(HASH_MAP_TO_PARSE).where({ :parses => { :parsable_id => parsables, :parsable_type => type }})
  }
  
  HASH_MAP_TO_PARSE = { :sense => Sense::HASH_MAP_TO_PARSE }
  
  # Default to the target_language of the lexeme's dictionaries if not defined
  before_save :set_defaults
  
  # Default to lexeme's language if language not defined.
  def set_defaults
    default_language = (Language.lang_for(sense.lexeme.dictionaries, :target_language) if sense.try(:lexeme)) || Language.new
 
    self.language ||= default_language
  end
  
  # Determine whether we should hit reject_if when something accepts_nested_attributes_for glosses.
protected
  def any_gloss_present?
    # attrs[:gloss].blank? # before we had i18n
    # attrs = attrs.attributes if attrs.is_a? Gloss
    unless translations.any? {|xlat| xlat.gloss.present? }
      errors.add(:gloss, I18n.t('errors.messages.blank'))
    end
  end
end
