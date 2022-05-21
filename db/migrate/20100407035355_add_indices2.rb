# frozen_string_literal: true

class AddIndices2 < ActiveRecord::Migration[4.2]
  def self.up
    add_index :headwords, :lexeme_id
    add_index :headwords, :form
    add_index :dictionary_scopes, :lexeme_id
    add_index :dictionary_scopes, :dictionary_id
    add_index :senses, :subentry_id
  end

  def self.down
    remove_index :senses, :subentry_id
    remove_index :dictionary_scopes, :dictionary_id
    remove_index :dictionary_scopes, :lexeme_id
    remove_index :headwords, :form
    remove_index :headwords, :lexeme_id
  end
end
