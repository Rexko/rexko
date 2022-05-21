# frozen_string_literal: true

class AddSourceAndVernacularLanguagesToDictionary < ActiveRecord::Migration[4.2]
  def self.up
    add_column :dictionaries, :source_language_id, :integer
    add_column :dictionaries, :target_language_id, :integer
  end

  def self.down
    remove_column :dictionaries, :target_language_id
    remove_column :dictionaries, :source_language_id
  end
end
