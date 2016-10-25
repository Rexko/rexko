class AddIndexToHeadwordAndParseTranslations < ActiveRecord::Migration
  def change
    add_index :headword_translations, :form
    add_index :parse_translations, :parsed_form
  end
end
