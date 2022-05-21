# frozen_string_literal: true

class TranslateLanguages < ActiveRecord::Migration[4.2]
  def up
    unless table_exists?(:language_translations)
      Language.create_translation_table!({
                                           default_name: :string
                                         }, { migrate_data: true })
    end
  end

  def down
    Language.drop_translation_table! migrate_data: true
  end
end
