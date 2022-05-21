# frozen_string_literal: true

class CreateSortOrders < ActiveRecord::Migration[4.2]
  def change
    create_table :sort_orders do |t|
      t.string :name
      t.text :substitutions
      t.text :orderings
      t.integer :language_id

      t.timestamps
    end

    add_index :sort_orders, :language_id
    add_column :dictionaries, :sort_order_id, :integer
    add_column :languages, :sort_order_id, :integer
  end
end
