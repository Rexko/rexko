class CreateDictionaryScopes < ActiveRecord::Migration
  def self.up
    drop_table :dictionaries_lexemes
    
    create_table :dictionary_scopes do |t|
      t.integer :dictionary_id
      t.integer :lexeme_id

      t.timestamps
    end
  end

  def self.down
    drop_table :dictionary_scopes

    create_table :dictionaries_lexemes do |t|
      t.integer :dictionary_id
      t.integer :lexeme_id

      t.timestamps
    end
  end
end
