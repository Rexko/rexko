class CreateLexemes < ActiveRecord::Migration[4.2]
  def self.up
    create_table :lexemes do |t|
      t.timestamps
    end
  end

  def self.down
    drop_table :lexemes
  end
end
