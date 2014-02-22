class AddAcceptanceToHeadwords < ActiveRecord::Migration
  def change
    add_column :headwords, :acceptance, :integer
    Headword.reset_column_information
    Headword.update_all acceptance: 3 
  end
end
