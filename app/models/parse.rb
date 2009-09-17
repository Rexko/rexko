class Parse < ActiveRecord::Base
  belongs_to :attestation, :include => :locus
#  delegate :loci, :to => '(attestation or return nil)'
  has_many :interpretations
  validates_presence_of :parsed_form
  
  named_scope :without_entries, :conditions => ['parsed_form NOT IN (SELECT form FROM "headwords" WHERE parses.parsed_form = headwords.form)']
  named_scope :uninterpreted, :include => :interpretations, :conditions => { "interpretations.parse_id" => nil }
  
  accepts_nested_attributes_for :interpretations, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
    
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
  
  def lookup_headword
    Headword.find_by_form(parsed_form)
  end

  def lookup_all_headwords
    Headword.find_all_by_form(parsed_form)
  end

  def potential_interpretations
    parsed_form && Sense.lookup_all_by_headword(parsed_form)
  end
  
  def count
    Parse.count(:conditions => {:parsed_form => parsed_form})
  end
end
