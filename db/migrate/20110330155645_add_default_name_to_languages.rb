class AddDefaultNameToLanguages < ActiveRecord::Migration[4.2]
  def self.up
    add_column :languages, :default_name, :string
  end

  def self.down
    remove_column :languages, :default_name
  end
end
