# frozen_string_literal: true

class Dictionary < ApplicationRecord
  has_many :dictionary_scopes # has_one?
  has_many :lexemes, through: :dictionary_scopes
  validates_presence_of :title
  validates_uniqueness_of :title
  belongs_to :language, optional: true # language of the dictionary's title; should also be  vernacular_language, language of definitions ## 'Should'?  ...
  belongs_to :source_language, optional: true, class_name: 'Language' # language of headwords
  belongs_to :target_language, optional: true, class_name: 'Language' # language of glosses
  belongs_to :sort_order, optional: true

  default_scope { includes(%i[language source_language target_language]) }

  def self.safe_params
    :title
  end

  def homographs_of(form)
    lexemes & Lexeme.lookup_all_by_headword(form)
  end

  def headword_language
    source_language.try(:iso_639_code) || 'und'
  end

  def gloss_language
    target_language.try(:iso_639_code) || 'und'
  end

  def definition_language
    language.try(:iso_639_code) || 'und'
  end

  def self.langs_hash_for(dicts)
    Language.langs_hash_for(dicts, vernacular: :language, source: :source_language, target: :target_language)
  end
end
