class TranslateSortOrders < ActiveRecord::Migration
  def up
    SortOrder.create_translation_table!({
      name:                 :string
    }, { migrate_data: true })
  end

  def down
    SortOrder.drop_translation_table! migrate_data: true
  end
end
