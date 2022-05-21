class Note < ApplicationRecord
  attribute :content

  belongs_to :language, optional: true
  belongs_to :annotatable, optional: true, polymorphic: true
  translates :content, fallbacks_for_empty_translations: true
  globalize_accessors locales: (Language.defined_language_codes | [I18n.default_locale])

  def self.safe_params
    [:_destroy, *Note.globalize_attribute_names]
  end
end
