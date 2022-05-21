# frozen_string_literal: true

class Orthograph < ApplicationRecord
  belongs_to :headword, optional: true
  belongs_to :phonetic_form, optional: true
end
