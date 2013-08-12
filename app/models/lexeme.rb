class Lexeme < ActiveRecord::Base
  has_many :dictionary_scopes
  has_many :dictionaries, :through => :dictionary_scopes
  has_many :subentries
  has_many :senses, :through => :subentries
  has_many :headwords
  has_many :phonetic_forms, :through => :headwords
  
  scope :sorted, order(Headword.arel_table[:form].asc)
  
  scope :attested_by, lambda {|parsables, type|
    joins(HASH_MAP_TO_PARSE).where({ :parses => { :parsable_id => parsables, :parsable_type => type }})
  }
  
  accepts_nested_attributes_for :dictionary_scopes, :dictionaries, :subentries, :headwords, :phonetic_forms, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  
  SUBSTRING = "contains"
  EXACT = "exact match"
  SEARCH_OPTIONS = [SUBSTRING, EXACT]

  HASH_MAP_TO_PARSE = { :subentries => Subentry::HASH_MAP_TO_PARSE }
 
  # Returns an array containing the forms of each headword.
  def headword_forms
    headwords.collect(&:form)
  end
  
  def primary_headword
    headwords.first.try(:form)
  end
  
  def loci(options = {})
    Locus.attesting(self).includes(options[:include])
    # old include:
    # :include => { :parses => { :interpretations => { :sense => { :subentry => { :lexeme => :headwords }}}}}
  end
  
  # Fetch all other lexemes sharing the same loci. If a dictionary is given, give all results in that 
  # dictionary.  Otherwise, fetch all results with any of the lexeme's headwords in its paradigm
  # that are linked wiki-style (e.g. [[foo]] or [[foo|bar]]).
  def constructions (from_dictionary = nil)
    heads = headword_forms.collect{|form| ["%[[" + form + "|%", "%[[" + form + "]]%"]}.flatten
    return {} if heads.empty?
    headlike = "(subentries.paradigm LIKE ?" + " OR subentries.paradigm LIKE ?" * (heads.length - 1) + ")"
    
    conditions = [('lexemes.id != ? %s AND %s' % 
      [("AND dictionaries.id = ?" if from_dictionary),
      headlike]), id, from_dictionary.try(:id), *heads].compact

    Lexeme.attested_by(loci.collect(&:attestations).flatten, "Attestation").where(conditions).includes([:headwords, :dictionaries, :subentries]).uniq
  end  
  
  # Return all lexemes with a headword matching a string or the string with
  # its first letter's case inverted (MediaWiki-style case insensitivity)
  def self.lookup_all_by_headword(form, options = {})
    lookup_all_by_headwords([form], options)
  end
  
  # Return all lexemes with a headword matching any of the given strings, ignoring
  # the case of the initial character.  
  def self.lookup_all_by_headwords(forms, options ={})
    forms = forms.compact.inject([]) do |memo, form|
      swapform = form.dup
      swapform[0,1] = swapform[0,1].swapcase
      memo << form << swapform
    end unless options[:initial_case_insensitive]
    
    case options[:matchtype] ||= EXACT
    when SUBSTRING
      headwords_like = "(headwords.form LIKE ?" + " OR headwords.form LIKE ?" * (forms.length - 1) + ")"
      wildcarded_forms = forms.collect {|form| "%#{form}%"}
      Lexeme.joins(:headwords).where([headwords_like, *wildcarded_forms]).includes(options[:include]).group(:lexeme_id)
    when EXACT
      Lexeme.joins(:headwords).where(["headwords.form IN (?)", forms]).includes(options[:include])
    end
  end
  
  # Return first lexeme with a headword matching a string or the string with
  # its first letter's case inverted (MediaWiki-style case insensitivity)
  def self.lookup_by_headword(form)
    swapform = form.dup
    swapform[0,1] = swapform[0,1].swapcase
    
    Lexeme.joins(:headwords).where(["headwords.form = ? OR headwords.form = ?", form, swapform]).first
  end
  
  # Return the language of the lexeme, based on the dictionaries it's in.   
  def language
		Language.lang_for(dictionaries, :source_language)
  end
  
  # Return all lexemes the parsables attest.
#  def Lexeme.attested_by parsables, type
#    Lexeme.find(:all, :joins => HASH_MAP_TO_PARSE, :conditions => { :parses => { :parsable_id => parsables, :parsable_type => type }})
#  end

	# Returns a list of headwords minus those that differ only in the casing
	# of the first letter.  
	def initial_case_insensitive_headwords
	  hw_forms = headword_forms.inject([]) do |memo, form|
      swapform = form.dup
      swapform[0,1] = swapform[0,1].swapcase
      
      memo.include?(swapform) ? memo : memo << form
    end

		headwords.reject do |hw|
			!hw_forms.include? hw.form
		end
	end
end