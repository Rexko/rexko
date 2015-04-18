class TranslateParses < ActiveRecord::Migration
  def up
    Parse.create_translation_table!({
      parsed_form:          :string
    }, { migrate_data: true })
  end

  def down
    Parse.drop_translation_table! migrate_data: true
  end
end
