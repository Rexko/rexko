class TranslateLanguages < ActiveRecord::Migration[4.2]
  def up
    Language.create_translation_table!({
      default_name:         :string
    }, { migrate_data: true })
  end

  def down
    Language.drop_translation_table! migrate_data: true
  end
end
