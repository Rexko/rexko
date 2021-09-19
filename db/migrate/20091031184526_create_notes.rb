class CreateNotes < ActiveRecord::Migration[4.2]
  def self.up
    create_table :notes do |t|
      t.text :content
      t.integer :language_id
      t.integer :annotatable_id
      t.string :annotatable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
