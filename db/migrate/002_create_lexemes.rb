class CreateLexemes < ActiveRecord::Migration
  def self.up
    create_table :lexemes do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :lexemes
  end
end
