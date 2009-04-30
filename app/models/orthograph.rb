class Orthograph < ActiveRecord::Base
  belongs_to :headword
  belongs_to :phonetic_form
end
