class AddExternalAddressToDictionaries < ActiveRecord::Migration
  def change
    add_column :dictionaries, :external_address, :string
  end
end
