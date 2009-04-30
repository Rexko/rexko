class DictionaryScope < ActiveRecord::Base
  belongs_to :dictionary
  belongs_to :lexeme
end
