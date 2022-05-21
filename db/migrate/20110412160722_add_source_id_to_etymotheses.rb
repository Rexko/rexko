# frozen_string_literal: true

class AddSourceIdToEtymotheses < ActiveRecord::Migration[4.2]
  def self.up
    add_column :etymotheses, :source_id, :integer
  end

  def self.down
    remove_column :etymotheses, :source_id
  end
end
