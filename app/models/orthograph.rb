class Orthograph < ApplicationRecord
  belongs_to :headword
  belongs_to :phonetic_form
end
