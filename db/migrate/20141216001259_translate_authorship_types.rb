class TranslateAuthorshipTypes < ActiveRecord::Migration[4.2]
  def up
    AuthorshipType.create_translation_table!({
      name:                :string 
    }, { migrate_data: true })
  end

  def down
    AuthorshipType.drop_translation_table! migrate_data: true
  end
end
