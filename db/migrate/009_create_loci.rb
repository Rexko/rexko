# frozen_string_literal: true

class CreateLoci < ActiveRecord::Migration[4.2]
  def self.up
    create_table :loci do |t|
      t.integer :source_id
      t.text :example
      t.text :example_translation

      t.timestamps
    end
  end

  def self.down
    drop_table :loci
  end
end
