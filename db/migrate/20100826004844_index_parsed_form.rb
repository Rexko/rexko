class IndexParsedForm < ActiveRecord::Migration
  def self.up
    add_index :parses, :parsed_form
  end

  def self.down
    remove_index :parses, :parsed_form
  end
end
