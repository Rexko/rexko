class CreateHeadwords < ActiveRecord::Migration
  def self.up
    create_table :headwords do |t|
      t.string :form

      t.timestamps
    end
  end

  def self.down
    drop_table :headwords
  end
end
