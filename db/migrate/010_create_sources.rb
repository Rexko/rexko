# frozen_string_literal: true

class CreateSources < ActiveRecord::Migration[4.2]
  def self.up
    create_table :sources do |t|
      t.string :author
      t.string :title
      t.string :pointer

      t.timestamps
    end
  end

  def self.down
    drop_table :sources
  end
end
