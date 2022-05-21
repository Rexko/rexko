# frozen_string_literal: true

class CreateSubentries < ActiveRecord::Migration[4.2]
  def self.up
    create_table :subentries do |t|
      t.integer :lexeme_id
      t.string :paradigm
      t.string :part_of_speech

      t.timestamps
    end
  end

  def self.down
    drop_table :subentries
  end
end
