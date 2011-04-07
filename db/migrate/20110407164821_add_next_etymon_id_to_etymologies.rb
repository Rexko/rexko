class AddNextEtymonIdToEtymologies < ActiveRecord::Migration
  def self.up
    add_column :etymologies, :next_etymon_id, :integer
  end

  def self.down
    remove_column :etymologies, :next_etymon_id
  end
end
