# frozen_string_literal: true

class TranslateParses < ActiveRecord::Migration[4.2]
  def up
    Parse.create_translation_table!({
                                      parsed_form: :string
                                    }, { migrate_data: true })
  end

  def down
    Parse.drop_translation_table! migrate_data: true
  end
end
