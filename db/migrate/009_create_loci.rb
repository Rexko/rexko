class CreateLoci < ActiveRecord::Migration
  def self.up
    create_table :loci do |t|
      t.integer :source_id
      t.text :example
      t.text :example_translation

      t.timestamps
    end
  end

  def self.down
    drop_table :loci
  end
end
