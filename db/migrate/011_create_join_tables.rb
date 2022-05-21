class CreateJoinTables < ActiveRecord::Migration[4.2]
  def self.up
    create_table :dictionaries_lexemes, id: false do |t|
      t.integer :dictionary_id, null: false
      t.integer :lexeme_id, null: false
    end
    create_table :headwords_lexemes, id: false do |t|
      t.integer :headword_id, null: false
      t.integer :lexeme_id, null: false
    end
    create_table :headwords_phonetic_forms, id: false do |t|
      t.integer :headword_id, null: false
      t.integer :phonetic_form_id, null: false
    end
    create_table :etymologies_subentries, id: false do |t|
      t.integer :etymology_id, null: false
      t.integer :subentry_id, null: false
    end
    create_table :glosses_senses, id: false do |t|
      t.integer :gloss_id, null: false
      t.integer :sense_id, null: false
    end
    create_table :loci_senses, id: false do |t|
      t.integer :locus_id, null: false
      t.integer :sense_id, null: false
    end
  end

  def self.down
    drop_table :loci_senses
    drop_table :glosses_senses
    drop_table :etymologies_subentries
    drop_table :headwords_phonetic_forms
    drop_table :headwords_lexemes
    drop_table :dictionaries_lexemes
  end
end
