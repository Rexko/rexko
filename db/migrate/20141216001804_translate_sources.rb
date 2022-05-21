# frozen_string_literal: true

class TranslateSources < ActiveRecord::Migration[4.2]
  def up
    Source.create_translation_table!({
                                       pointer: :string
                                     }, { migrate_data: true })
  end

  def down
    Source.drop_translation_table! migrate_data: true
  end
end
