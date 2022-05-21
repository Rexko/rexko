# frozen_string_literal: true

class DictionaryScope < ApplicationRecord
  belongs_to :dictionary
  belongs_to :lexeme

  def self.safe_params
    %i[dictionary_id lexeme_id]
  end
end
