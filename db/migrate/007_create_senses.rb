class CreateSenses < ActiveRecord::Migration
  def self.up
    create_table :senses do |t|
      t.integer :subentry_id
      t.text :definition

      t.timestamps
    end
  end

  def self.down
    drop_table :senses
  end
end
