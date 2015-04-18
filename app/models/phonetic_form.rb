class PhoneticForm < ActiveRecord::Base
#  has_and_belongs_to_many :headwords # why?
  has_many :orthographs
  has_many :headwords, :through => :orthographs
  translates :form, :fallbacks_for_empty_translations => true
  globalize_accessors :locales => (Language.all.collect(&:iso_639_code) | [I18n.default_locale])
 
  validates_presence_of :form
end
