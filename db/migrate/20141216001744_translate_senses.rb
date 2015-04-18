class TranslateSenses < ActiveRecord::Migration
  def up
    Sense.create_translation_table!({
      definition:           :text
    }, { migrate_data: true })
  end

  def down
    Sense.drop_translation_table! migrate_data: true
  end
end
