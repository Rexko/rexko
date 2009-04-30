class CreateOrthographs < ActiveRecord::Migration
  def self.up
    drop_table :headwords_phonetic_forms
    
    create_table :orthographs do |t|
      t.integer :headword_id
      t.integer :phonetic_form_id
      t.timestamps
    end
  end

  def self.down
    drop_table :orthographs
    
    create_table :headwords_phonetic_forms, :id => false do |t|
      t.integer :headword_id, :null => false
      t.integer :phonetic_form_id, :null => false
    end
  end
end
