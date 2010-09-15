class Lexeme < ActiveRecord::Base
  has_many :dictionary_scopes
  has_many :dictionaries, :through => :dictionary_scopes
  has_many :subentries
  has_many :senses, :through => :subentries
  has_many :headwords
  has_many :phonetic_forms
  
  accepts_nested_attributes_for :dictionary_scopes, :dictionaries, :subentries, :headwords, :phonetic_forms, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
 
  def headword_forms
    headwords.collect(&:form)
  end
 
  def loci(options = {})
    Locus.attesting(self).find(:all, :include => options[:include])
    # old include:
    # :include => { :parses => { :interpretations => { :sense => { :subentry => { :lexeme => :headwords }}}}}
  end
  
  # Fetch all other lexemes sharing the same loci. If a dictionary is given, give all results in that 
  # dictionary.  Otherwise, fetch all results containing a space.
  def constructions (from_dictionary = nil)
    Lexeme.find(:all, :select => 'DISTINCT "lexemes".*', :joins => { :senses => { :parses => { :attestation => { :locus => { :attestations => { :parses => { :interpretations => { :sense => { :subentry => :lexeme }}}}}}}}}, :include => [:headwords, :dictionaries], :conditions => from_dictionary ? ['lexemes.id != ? AND dictionaries.id = ? AND "lexemes_subentries".id = ?', id, from_dictionary.id, id] : ['lexemes.id != ? AND headwords.form LIKE "% %" AND "lexemes_subentries".id = ?', id, id])
  end  
  
  # Return all lexemes with a headword matching a string or the string with
  # its first letter's case inverted (MediaWiki-style case insensitivity)
  def self.lookup_all_by_headword(form, options = {})
    swapform = form.dup
    swapform[0,1] = swapform[0,1].swapcase
    
    Lexeme.find(:all, :joins => :headwords, :conditions => ["headwords.form = ? OR headwords.form = ?", form, swapform], :include => options[:include])
    # old include:
    # :include => [:dictionaries, {:subentries => [{:senses => :glosses}, :etymologies]}]
  end
  
  # Return first lexeme with a headword matching a string or the string with
  # its first letter's case inverted (MediaWiki-style case insensitivity)
  def self.lookup_by_headword(form)
    swapform = form.dup
    swapform[0,1] = swapform[0,1].swapcase
    
    Lexeme.find(:first, :joins => :headwords, :conditions => ["headwords.form = ? OR headwords.form = ?", form, swapform])
  end
end