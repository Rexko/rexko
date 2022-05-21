# frozen_string_literal: true

class AddIndices < ActiveRecord::Migration[4.2]
  def self.up
    add_index :subentries, :lexeme_id
    add_index :interpretations, :sense_id
    add_index :interpretations, :parse_id
    add_index :parses, :attestation_id
    add_index :attestations, :locus_id
  end

  def self.down
    remove_index :attestations, :locus_id
    remove_index :parses, :attestation_id
    remove_index :interpretations, :parse_id
    remove_index :interpretations, :sense_id
    remove_index :subentries, :lexeme_id
  end
end
