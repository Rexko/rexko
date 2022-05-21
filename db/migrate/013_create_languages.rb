# frozen_string_literal: true

class CreateLanguages < ActiveRecord::Migration[4.2]
  def self.up
    create_table :languages do |t|
      t.string :iso_639_code

      t.timestamps
    end

    add_column :dictionaries, :language_id, :integer
    add_column :etymologies, :language_id, :integer
    add_column :glosses, :language_id, :integer
    add_column :headwords, :language_id, :integer
    add_column :senses, :language_id, :integer
    add_column :subentries, :language_id, :integer

    # This is added later but stuff depends on it now
    create_table 'language_translations', force: :cascade do |t|
      t.integer 'language_id'
      t.string 'locale', null: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.string 'default_name'
      t.index ['language_id'], name: 'index_language_translations_on_language_id'
      t.index ['locale'], name: 'index_language_translations_on_locale'
    end
  end

  def self.down
    drop_table 'language_translations' do |t|
      t.integer 'language_id'
      t.string 'locale', null: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.string 'default_name'
      t.index ['language_id'], name: 'index_language_translations_on_language_id'
      t.index ['locale'], name: 'index_language_translations_on_locale'
    end

    remove_column :subentries, :language_id
    remove_column :senses, :language_id
    remove_column :headwords, :language_id
    remove_column :glosses, :language_id
    remove_column :etymologies, :language_id
    remove_column :dictionaries, :language_id

    drop_table :languages
  end
end
