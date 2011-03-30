class AddDefaultNameToLanguages < ActiveRecord::Migration
  def self.up
    add_column :languages, :default_name, :string
  end

  def self.down
    remove_column :languages, :default_name
  end
end
