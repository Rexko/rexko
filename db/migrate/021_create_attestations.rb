# frozen_string_literal: true

class CreateAttestations < ActiveRecord::Migration[4.2]
  def self.up
    drop_table :loci_senses

    create_table :attestations do |t|
      t.integer :locus_id
      t.integer :sense_id
      t.timestamps
    end
  end

  def self.down
    drop_table :attestations

    create_table :loci_senses, id: false do |t|
      t.integer :locus_id, null: false
      t.integer :sense_id, null: false
    end
  end
end
