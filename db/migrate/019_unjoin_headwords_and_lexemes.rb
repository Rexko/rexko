class UnjoinHeadwordsAndLexemes < ActiveRecord::Migration[4.2]
  def self.up
    # add lexeme_id column to headword
    add_column :headwords, :lexeme_id, :integer
            
    # drop the headwords_lexemes table
    drop_table :headwords_lexemes
  end

  def self.down
    # create the headwords_lexemes table
    create_table :headwords_lexemes, :id => false do |t|
      t.integer :headword_id, :null => false
      t.integer :lexeme_id, :null => false
    end
    
    # take all the information from the gloss's sense_id colum and copy the
    # appropriate sense_id and gloss_id to new glosses_senses
    # I don't think this will work without changing stuff back to habtm first.  Wontfix.
    
    # remove sense_id column from gloss
    remove_column :headwords, :lexeme_id
  end
end