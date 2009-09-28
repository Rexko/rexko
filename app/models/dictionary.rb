class Dictionary < ActiveRecord::Base
  has_many :dictionary_scopes # has_one?
  has_many :lexemes, :through => :dictionary_scopes
  validates_presence_of :title
  validates_uniqueness_of :title
  belongs_to :language  # language of the dictionary's title; should also be  vernacular_language, language of definitions ## 'Should'?  ...
  belongs_to :source_language, :class_name => "Language" # language of headwords
  belongs_to :target_language, :class_name => "Language" # language of glosses
  
  def homographs_of (form)
    lexemes & Lexeme.lookup_all_by_headword(form)
  end
end
