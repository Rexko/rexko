# frozen_string_literal: true

class CreateLexemes < ActiveRecord::Migration[4.2]
  def self.up
    create_table :lexemes, &:timestamps
  end

  def self.down
    drop_table :lexemes
  end
end
