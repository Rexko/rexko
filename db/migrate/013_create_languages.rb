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
  end

  def self.down
    remove_column :subentries, :language_id
    remove_column :senses, :language_id
    remove_column :headwords, :language_id
    remove_column :glosses, :language_id
    remove_column :etymologies, :language_id
    remove_column :dictionaries, :language_id

    drop_table :languages
  end
end
