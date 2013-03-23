class Locus < ActiveRecord::Base
  belongs_to :source
  has_many :attestations, :dependent => :destroy
  has_many :parses, :through => :attestations

	scope :sorted, order(Author.arel_table[:name].asc).order(Title.arel_table[:name].asc).order(Source.arel_table[:pointer].asc)

  # Takes a lexeme and returns 
  scope :attesting, lambda { |lexeme|
    { :joins => { :attestations => { :parses => { :interpretations => { :sense => :subentry }}}},
    :conditions => { :subentries => { :lexeme_id => [*lexeme].collect(&:id) }},
    :group => 'loci.id' }
  }
  
  scope :unattached, lambda {|lexeme|
    { :joins => "INNER JOIN attestations ON attestations.locus_id = loci.id INNER JOIN parses ON (parses.parsable_id = attestations.id AND parses.parsable_type = 'Attestation') LEFT OUTER JOIN interpretations ON interpretations.parse_id = parses.id",
     :conditions => { "interpretations.parse_id" => nil, "parses.parsed_form" => [*lexeme].collect(&:headword_forms) }
    }
  }

  scope :possibly_construing_with, lambda {|attested_forms|
    attesting(Lexeme.lookup_all_by_headwords(attested_forms))
  }
  
  accepts_nested_attributes_for :attestations, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }

  # Returns the parse with the most attestations that doesn't have an entry yet. 
  # I guess this should be part of Parse now
  def most_wanted_parse
    Parse.select('"parses".id, "parses"."parsed_form",  COUNT("parsed_form") AS count_all').joins(['INNER JOIN "attestations" ON ("parses"."parsable_id" = "attestations".id AND "parses"."parsable_type" = \'Attestation\') LEFT OUTER JOIN "headwords" ON ("headwords"."form" = "parses"."parsed_form")']).group('"parses"."parsed_form"').where({:headwords => {:form => nil}}).order('count_all DESC').having({:attestations => {:locus_id => id}}).first
  end
  
  # Returns true if form attests either an attested_form or a parsed_form under this locus.
  # Option to limit to one or the other may be needed later.
  def attests? form
     (attestations.collect(&:attested_form) + Parse.forms_of(parses)).include? form
  end

	# Given an Author or array of Authors, return all loci authored by them.
  def self.authored_by author_array
		Locus.joins( :source => :authorship ).where( :authorships => { :author_id => author_array }).uniq
	end
	
	# Return other loci that attest two lexemes in common with this one, arranged by which two lexemes.
	#
	# Return value is a hash like { ["attest", "phrase"] => { :phrase => ["attested phrase", ...], :loci => [locus1, locus2, locus3, ...] } }
	def potential_constructions
	  parses = attestations.inject([]) do |memo, att|
	    att.parses.collect(&:parsed_form).each do |pf|
	      memo << [att.attested_form, pf]
	    end
      memo
	  end

	  construes = parses.collect do |forms|
	    [forms[0], forms[1], Locus.possibly_construing_with([forms[1]]).where(Locus.arel_table[:id].not_eq(self.id))]
	  end

    potentials = {}
    loop do
      attest, parse, loci = construes.shift
      break unless parse

      construes.each do |c_attest, c_parse, c_loci|
        construe = { [parse, c_parse] => { :phrase => ["%s %s" % [attest, c_attest]], :loci => loci & c_loci } }
        potentials.update (construe) do |key, oldval, newval|
          oldval.merge(newval) do |key, oldval, newval|
            oldval | newval 
          end
        end
      end
    end 

    potentials.delete_if {|k,v| v[:loci].blank?}
  end
end
