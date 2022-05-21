# frozen_string_literal: true

class AddIndexToHeadwordAndParseTranslations < ActiveRecord::Migration[4.2]
  def change
    add_index :headword_translations, :form
    add_index :parse_translations, :parsed_form
  end
end
