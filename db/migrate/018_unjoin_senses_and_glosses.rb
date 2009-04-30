class UnjoinSensesAndGlosses < ActiveRecord::Migration
  def self.up
    # add sense_id column to gloss
    add_column :glosses, :sense_id, :integer
    
    # Go through all senses, and assign their id to their glosses directly. 
    # This will act up if someone got clever and started linking glosses to multiple senses
    # Doesn't seem to work anyway.  Oh well.
    senses = Sense.find(:all)
    for sense in senses
      for gloss in sense.glosses
        gloss.sense_id = sense.id
        gloss.save
      end
    end
    
    # drop the glosses_senses table
    drop_table :glosses_senses
  end

  def self.down
    # create the glosses_senses table
    create_table :glosses_senses, :id => false do |t|
      t.integer :gloss_id, :null => false
      t.integer :sense_id, :null => false
    end
    
    # take all the information from the gloss's sense_id colum and copy the
    # appropriate sense_id and gloss_id to new glosses_senses
    # I don't think this will work without changing stuff back to habtm first.  Wontfix.
    
    # remove sense_id column from gloss
    remove_column :glosses, :sense_id
  end
end
