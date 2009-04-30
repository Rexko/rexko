class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.string :author
      t.string :title
      t.string :pointer

      t.timestamps
    end
  end

  def self.down
    drop_table :sources
  end
end
