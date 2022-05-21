# frozen_string_literal: true

class AddExternalAddressToDictionaries < ActiveRecord::Migration[4.2]
  def change
    add_column :dictionaries, :external_address, :string
  end
end
