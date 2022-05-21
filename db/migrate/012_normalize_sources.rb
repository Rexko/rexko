# frozen_string_literal: true

class NormalizeSources < ActiveRecord::Migration[4.2]
  def self.up
    remove_column :sources, :title
    remove_column :sources, :author
    add_column :sources, :title_id, :integer

    create_table :titles do |t|
      t.string :name
      t.timestamps
    end

    create_table :authors do |t|
      t.string :name
      t.timestamps
    end

    create_table :authors_titles, id: false do |t|
      t.integer :author_id, null: false
      t.integer :title_id, null: false
    end
  end

  def self.down
    drop_table :authors_titles
    drop_table :authors
    drop_table :titles
    remove_column :sources, :title_id
    add_column :sources, :author, :string
    add_column :sources, :title, :string
  end
end
