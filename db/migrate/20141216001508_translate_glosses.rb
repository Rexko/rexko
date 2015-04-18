class TranslateGlosses < ActiveRecord::Migration
  def up
    Gloss.create_translation_table!({
      gloss:               :string
    }, { migrate_data: true })
  end

  def down
    Gloss.drop_translation_table! migrate_data: true
  end
end
