class CreateParses < ActiveRecord::Migration[4.2]
  def self.up
    remove_column :attestations, :sense_id
    add_column :attestations, :attested_form, :string
    
    create_table :parses do |t|
      t.integer :attestation_id
      t.string :parsed_form

      t.timestamps
    end
  end

  def self.down
    drop_table :parses
    
    remove_column :attestations, :attested_form
    add_column :attestations, :sense_id, :integer
  end
end
