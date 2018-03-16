class Note < ActiveRecord::Base
  belongs_to :language
  belongs_to :annotatable, :polymorphic => true
  translates :content, :fallbacks_for_empty_translations => true
  globalize_accessors :locales => (Language.defined_language_codes | [I18n.default_locale])
  
  def self.safe_params
    [:_destroy, *Note.globalize_attribute_names]
  end
end
