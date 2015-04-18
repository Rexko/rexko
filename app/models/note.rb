class Note < ActiveRecord::Base
  belongs_to :language
  belongs_to :annotatable, :polymorphic => true
  translates :content, :fallbacks_for_empty_translations => true
  globalize_accessors :locales => (Language.all.collect(&:iso_639_code) | [I18n.default_locale])
  
end
