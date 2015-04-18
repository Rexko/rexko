class TranslateEtymologies < ActiveRecord::Migration
  def up
    Etymology.create_translation_table!({
      etymon:              :string,
      gloss:               :string
    }, { migrate_data: true })
  end

  def down
    Etymology.drop_translation_table! migrate_data: true
  end
end
