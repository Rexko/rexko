class OverhaulBiblio < ActiveRecord::Migration[4.2]
  def change
    create_table :authorship_types do |t|
      t.string :name
      
      t.timestamps
    end
    
    change_table :authorships do |t|
      t.string :year
      t.integer :authorship_type_id
    end

    remove_column :authorships, :primary_author, :boolean
    remove_column :authorships, :contributor, :boolean
    remove_column :authorships, :quoted, :boolean

    change_table :authors do |t|
      t.string :romanized_name
      t.string :short_name
      t.string :sort_key
    end
    
    change_table :titles do |t|
      t.string :publication_year
      t.string :publisher
      t.string :publication_place
      t.string :url
      t.date :access_date
    end
  end
end
