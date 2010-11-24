class Locus < ActiveRecord::Base
  belongs_to :source
  has_many :attestations
  has_many :parses, :through => :attestations

  # Takes a lexeme and returns 
  named_scope :attesting, lambda { |lexeme|
    { :joins => { :attestations => { :parses => { :interpretations => { :sense => :subentry }}}},
    :conditions => { :subentries => { :lexeme_id => [*lexeme].collect(&:id) }} }
  }
  
  named_scope :unattached, lambda {|lexeme|
    { :joins => "INNER JOIN attestations ON attestations.locus_id = loci.id INNER JOIN parses ON parses.attestation_id = attestations.id LEFT OUTER JOIN interpretations ON interpretations.parse_id = parses.id",
     :conditions => { "interpretations.parse_id" => nil, "parses.parsed_form" => lexeme.headword_forms }          
    }
  }
  
  accepts_nested_attributes_for :attestations, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }

  # Returns the parse with the most attestations that doesn't have an entry yet. 
  # I guess this should be part of Parse now
  def most_wanted_parse
    Parse.find(:first, :select => '"parses".id, "parses"."parsed_form",  COUNT("parsed_form") AS count_all', :joins => ['INNER JOIN "attestations" ON "parses"."attestation_id" = "attestations".id LEFT OUTER JOIN "headwords" ON ("headwords"."form" = "parses"."parsed_form")'], :group => '"parses"."parsed_form"', :conditions => {:headwords => {:form => nil}}, :order => 'count_all DESC', :having => {:attestations => {:locus_id => id}})
  end
end
