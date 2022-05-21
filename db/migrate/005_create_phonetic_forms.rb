# frozen_string_literal: true

class CreatePhoneticForms < ActiveRecord::Migration[4.2]
  def self.up
    create_table :phonetic_forms do |t|
      t.string :form

      t.timestamps
    end
  end

  def self.down
    drop_table :phonetic_forms
  end
end
