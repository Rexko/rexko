class AddSourceIdToEtymotheses < ActiveRecord::Migration
  def self.up
    add_column :etymotheses, :source_id, :integer
  end

  def self.down
    remove_column :etymotheses, :source_id
  end
end
