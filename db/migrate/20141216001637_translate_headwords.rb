# frozen_string_literal: true

class TranslateHeadwords < ActiveRecord::Migration[4.2]
  def up
    Headword.create_translation_table!({
                                         form: :string
                                       }, { migrate_data: true })
  end

  def down
    Headword.drop_translation_table! migrate_data: true
  end
end
