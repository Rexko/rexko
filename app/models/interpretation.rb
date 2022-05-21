# frozen_string_literal: true

class Interpretation < ApplicationRecord
  belongs_to :parse, optional: true
  belongs_to :sense

  accepts_nested_attributes_for :sense, reject_if: :all_blank

  HASH_MAP_TO_PARSE = :parse
  # ARel conditions for whether this interpretation is linking a parse to a sense
  NOT_INTERPRETING = arel_table[:parse_id].eq(nil).or(arel_table[:sense_id].eq(nil))

  def self.safe_params
    [:id, :sense_id, :sense, { sense_attributes: Sense.safe_params }]
  end
end
