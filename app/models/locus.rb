class Locus < ActiveRecord::Base
  belongs_to :source
  has_many :attestations, :dependent => :destroy
  has_many :parses, :through => :attestations
  delegate :author, to: :source, allow_nil: true
  # Not till we have a sensible UI for this:
  # translates :example, :example_translation
  
  scope :sorted, -> { order(Author.arel_table[:name].asc).order(Title.arel_table[:name].asc).order(Source.arel_table[:pointer].asc) }

	# Given an Author or array of Authors, return all loci authored by them.
  scope :authored_by, ->(author_array) { joins( :source => :authorship ).where( :authorships => { :author_id => author_array }).uniq }

  # Takes a lexeme, sense, string, or an array of each, and returns the loci that attest the input
  scope :attesting, lambda { |obj|
    case [*obj].first
    when Lexeme
      joins(:attestations => { :parses => { :interpretations => { :sense => :subentry }}}) \
      .where(:subentries => { :lexeme_id => [*obj].collect(&:id) }) \
      .group('loci.id')
    when String
      includes(:parses => :translations).
      where(Attestation.arel_table[:attested_form].eq(obj).
      or(Parse::Translation.arel_table[:parsed_form].eq(obj)))
    when Sense
      joins(:attestations => { :parses => :interpretations }) \
      .where(:interpretations => { :sense_id => [*obj].collect(&:id) }) \
      .group('loci.id')
    end
  }
  
  scope :unattached, lambda {|lexeme|
    joins("INNER JOIN attestations ON attestations.locus_id = loci.id INNER JOIN parses ON (parses.parsable_id = attestations.id AND parses.parsable_type = 'Attestation') LEFT OUTER JOIN interpretations ON interpretations.parse_id = parses.id") \
    .where( "interpretations.parse_id" => nil, "parses.parsed_form" => [*lexeme].collect(&:headword_forms))
  }

  scope :possibly_construing_with, lambda {|attested_forms|
    select('"loci".*, "parses"."parsed_form"').joins(:attestations => { :parses => { :interpretations => { :sense => :subentry }}}).where( :subentries => { :lexeme_id => Lexeme.lookup_all_by_headwords(attested_forms).collect(&:id) })
  }
  
  accepts_nested_attributes_for :attestations, :source, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }

  def self.safe_params
    [:example, :attestations_attributes]
  end
  
  # Returns the parse with the most attestations that doesn't have an entry yet. 
  def most_wanted_parse
    Parse.most_wanted_in(self).first
  end
  
  # Returns true if form attests either an attested_form or a parsed_form under this locus.
  # Option to limit to one or the other may be needed later.
  def attests? form
     (attestations.collect(&:attested_form) + Parse.forms_of(parses)).include? form
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

    raw_construes = Locus.possibly_construing_with(parses.collect{|f| f[1]}).includes({:source => [{:authorship => [{:author => :translations}, {:title => :translations}]}, :translations], :parses => [:translations, {:interpretations => {:sense => :translations}}]}).where(Locus.arel_table[:id].not_eq(self.id))
    grouped_construes = raw_construes.group_by {|l| l.parsed_form}


	  construes = parses.collect do |forms|
      # For whatever reason, when the same Locus is returned multiple times in raw_construes, only the first one has the eager-loaded data.
      loci = (grouped_construes[forms[1]] || []).collect do |gcl|
        raw_construes.find{|l| l.id == gcl.id }
      end
	    [forms[0], forms[1], (loci || [])]
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
  
  # given a set of loci, return authors of those loci
  def self.authors(*loci)
    loci.collect do |l|
      l.first.author
    end.uniq
  end
  
  # Returns a hash of {author => loci authored by author attesting construction}
  # This appears to be an ugly hack and the need for it should be eliminated
  def self.loci_by_authors_hash(construction, *authors)
    Hash[authors.collect {|author| 
      [author, 
        Locus.where(:id => construction.loci).attesting(construction).authored_by(author)
      ] 
    }]
  end
end
