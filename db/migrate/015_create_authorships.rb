class CreateAuthorships < ActiveRecord::Migration[4.2]
  def self.up
    drop_table :authors_titles

    create_table :authorships do |t|
      t.integer :author_id
      t.integer :title_id
      t.boolean :primary_author
      t.boolean :contributor
      t.boolean :quoted
      t.timestamps
    end

    remove_column :sources, :title_id
    add_column :sources, :authorship_id, :integer
  end

  def self.down
    remove_column :sources, :authorship_id
    add_column :sources, :title_id, :integer

    drop_table :authorships

    create_table :authors_titles, id: false do |t|
      t.integer :author_id, null: false
      t.integer :title_id, null: false
    end
  end
end
