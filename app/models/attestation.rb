class Attestation < ActiveRecord::Base
  belongs_to :locus
  has_many :parses
  validates_presence_of :attested_form
  
  def parse=(parse_params)
    parse_params.each do |id, attributes|
      this_parse = Parse.find(id)
      if attributes
        this_parse.update_attributes(attributes)
      else
        parses.delete(this_parse)
      end
    end
  end
end
