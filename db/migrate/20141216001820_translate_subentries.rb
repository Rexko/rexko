class TranslateSubentries < ActiveRecord::Migration[4.2]
  def up
    Subentry.create_translation_table!({
                                         paradigm: :string,
                                         part_of_speech: :string
                                       }, { migrate_data: true })
  end

  def down
    Subentry.drop_translation_table! migrate_data: true
  end
end
