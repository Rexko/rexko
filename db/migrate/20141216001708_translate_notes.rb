class TranslateNotes < ActiveRecord::Migration
  def up
    Note.create_translation_table!({
      content:              :text
    }, { migrate_data: true })
  end

  def down
    Note.drop_translation_table! migrate_data: true
  end
end
