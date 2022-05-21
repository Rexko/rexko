# frozen_string_literal: true

class TranslateTitles < ActiveRecord::Migration[4.2]
  def up
    Title.create_translation_table!({
                                      name: :string,
                                      publisher: :string,
                                      publication_place: :string,
                                      url: :string
                                    }, { migrate_data: true })
  end

  def down
    drop_translation_table! migrate_data: true
  end
end
