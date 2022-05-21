# frozen_string_literal: true

class Attestation < ApplicationRecord
  belongs_to :locus, optional: true
  has_many :parses, as: :parsable, dependent: :destroy
  validates_presence_of :attested_form

  accepts_nested_attributes_for :parses, allow_destroy: true, reject_if: proc { |attributes|
                                                                           attributes.all? do |_k, v|
                                                                             v.blank?
                                                                           end
                                                                         }

  def self.safe_params
    [:id, :attested_form, { parses_attributes: Parse.safe_params }]
  end

  # In doing update on an attestation from the Loci form, we
  # we pass on each parse to Parse#update.  If there are no
  # attributes—Parse validates the presence of its parsed_form—delete the
  # parse.
  # There is almost certainly a better way to do this.
  # I am also entirely certain the parses.delete will a) not work and b)
  # never be called anyway.

  def parse=(parse_params)
    parse_params.each do |id, attributes|
      this_parse = Parse.find(id)
      p this_parse
      if attributes
        this_parse.update(attributes)
        #       Parse.update(id, attributes)
        #        this_parse.parsed_form = attributes["parsed_form"]
        #        this_parse.save
        p this_parse
        save
      else
        parses.delete(this_parse)
      end
    end
  end
end
