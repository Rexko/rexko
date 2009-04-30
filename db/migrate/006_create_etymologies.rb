class CreateEtymologies < ActiveRecord::Migration
  def self.up
    create_table :etymologies do |t|
      t.string :etymon
      t.string :source_language
      t.string :gloss

      t.timestamps
    end
  end

  def self.down
    drop_table :etymologies
  end
end
