class DictionaryScope < ApplicationRecord
  belongs_to :dictionary
  belongs_to :lexeme
  
  def self.safe_params
    [:dictionary_id, :lexeme_id]
  end
end
