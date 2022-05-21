# frozen_string_literal: true

class CreateEtymotheses < ActiveRecord::Migration[4.2]
  def self.up
    drop_table :etymologies_subentries

    create_table :etymotheses do |t|
      t.integer :etymology_id
      t.integer :subentry_id

      t.timestamps
    end
  end

  def self.down
    drop_table :etymotheses

    create_table :etymologies_subentries, id: false do |t|
      t.integer :etymology_id, null: false
      t.integer :subentry_id, null: false
    end
  end
end
