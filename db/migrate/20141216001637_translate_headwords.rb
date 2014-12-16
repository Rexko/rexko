class TranslateHeadwords < ActiveRecord::Migration
  def up
    Headword.create_translation_table!({
      form:                 :string
    }, { migrate_data: true })
  end

  def down
    Headword.drop_translation_table! migrate_data: true
  end
end
