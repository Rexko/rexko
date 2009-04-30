class Locus < ActiveRecord::Base
  belongs_to :source
  has_many :attestations
#  has_many :senses, :through => :attestations
  has_many :parses, :through => :attestations

  def attestation=(attestation_params)
    attestation_params.each do |id, attributes|
      this_attestation = Attestation.find(id)
      if attributes
        this_attestation.update_attributes(attributes)
      else
        attestations.delete(this_attestation)
      end
    end
  end
end
