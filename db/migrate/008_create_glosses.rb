class CreateGlosses < ActiveRecord::Migration
  def self.up
    create_table :glosses do |t|
      t.string :gloss

      t.timestamps
    end
  end

  def self.down
    drop_table :glosses
  end
end
