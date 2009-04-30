class Parse < ActiveRecord::Base
  belongs_to :attestation, :include => :locus
#  delegate :loci, :to => '(attestation or return nil)'
  has_many :interpretations
  validates_presence_of :parsed_form
  
  def interpretation=(terp_params)
    terp_params.each do |id, attributes|
      this_terp = Interpretation.find(id)
      if attributes
        this_terp.update_attributes(attributes)
      else
        interpretations.delete(this_terp)
      end
    end
  end
end
