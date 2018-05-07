class DictionaryScope < ApplicationRecord
  belongs_to :dictionary
  belongs_to :lexeme
end
