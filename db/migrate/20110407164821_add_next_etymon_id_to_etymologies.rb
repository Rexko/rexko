class AddNextEtymonIdToEtymologies < ActiveRecord::Migration[4.2]
  def self.up
    add_column :etymologies, :next_etymon_id, :integer
  end

  def self.down
    remove_column :etymologies, :next_etymon_id
  end
end
