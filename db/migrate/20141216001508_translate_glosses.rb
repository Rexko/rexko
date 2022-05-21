# frozen_string_literal: true

class TranslateGlosses < ActiveRecord::Migration[4.2]
  def up
    Gloss.create_translation_table!({
                                      gloss: :string
                                    }, { migrate_data: true })
  end

  def down
    Gloss.drop_translation_table! migrate_data: true
  end
end
