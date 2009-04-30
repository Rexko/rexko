class CreateInterpretations < ActiveRecord::Migration
  def self.up
    create_table :interpretations do |t|
      t.integer :parse_id
      t.integer :sense_id

      t.timestamps
    end
  end

  def self.down
    drop_table :interpretations
  end
end
