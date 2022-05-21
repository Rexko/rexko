# frozen_string_literal: true

class TranslateAuthors < ActiveRecord::Migration[4.2]
  def up
    Author.create_translation_table!({
                                       name: :string,
                                       short_name: :string,
                                       romanized_name: :string,
                                       sort_key: :string
                                     }, { migrate_data: true })
  end

  def down
    Author.drop_translation_table! migrate_data: true
  end
end
