# frozen_string_literal: true

class TranslateNotes < ActiveRecord::Migration[4.2]
  def up
    Note.create_translation_table!({
                                     content: :text
                                   }, { migrate_data: true })
  end

  def down
    Note.drop_translation_table! migrate_data: true
  end
end
