class AddParsableTypeToParses < ActiveRecord::Migration[4.2]
  def self.up
    add_column :parses, :parsable_type, :string
    rename_column :parses, :attestation_id, :parsable_id

    # All parsables before this point were attestations
    Parse.update_all("parsable_type = 'Attestation'")
  end

  def self.down
    rename_column :parses, :parsable_id, :attestation_id
    remove_column :parses, :parsable_type
  end
end
