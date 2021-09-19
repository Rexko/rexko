class CreateDictionaries < ActiveRecord::Migration[4.2]
  def self.up
    create_table :dictionaries do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :dictionaries
  end
end
