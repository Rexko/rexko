# frozen_string_literal: true

class CreateSenses < ActiveRecord::Migration[4.2]
  def self.up
    create_table :senses do |t|
      t.integer :subentry_id
      t.text :definition

      t.timestamps
    end
  end

  def self.down
    drop_table :senses
  end
end
