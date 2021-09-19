class AddAcceptanceToHeadwords < ActiveRecord::Migration[4.2]
  class Headword < ActiveRecord::Base
  end
  
  def change
    add_column :headwords, :acceptance, :integer
    Headword.reset_column_information
    Headword.update_all acceptance: 3 
  end
end
