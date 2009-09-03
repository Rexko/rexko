class Lexeme < ActiveRecord::Base
  has_many :dictionary_scopes
  has_many :dictionaries, :through => :dictionary_scopes
  has_many :subentries
  has_many :senses, :through => :subentries
  has_many :headwords
  has_many :phonetic_forms
  
  accepts_nested_attributes_for :dictionary_scopes, :dictionaries, :subentries, :headwords, :phonetic_forms, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  
  def loci
    Parse.find(senses.collect(&:parse_ids).flatten).collect(&:attestation).compact.collect(&:locus).uniq
  end
  
  def constructions (from_dictionary = nil)
    # Goal in brief.
    # Get a list of every lexeme in a dictionary of our choice (!) 
    # ...which appears in loci with this word.
    
    # First then, a list of all the loci of this word
    # (loci was moved to its own method)
    
    # Then, a list of all the other words appearing in these loci
    # => why teh flattens?  the methods that return arrays... maybe we could simplify that.
    fellows = loci.collect(&:parses).flatten.collect(&:interpretations).flatten.collect(&:sense).collect(&:lexeme).uniq - [self]
    
    # for bug 7 [28] - constructions are multi-word; delete what isn't
    fellows.delete_if do |fellow| 
      fellow.headwords.any? do |headword|
        ! headword.form.include? " "
      end
    end
    
    # Then, if from_dictionary is given, limit it to that dictionary; otherwise
    # return all.
    from_dictionary.nil? ? fellows : from_dictionary.lexemes.find(fellows)
  end
  
  # Return all lexemes with a headword matching a string or the string with
  # its first letter's case inverted (MediaWiki-style case insensitivity)
  def self.lookup_all_by_headword(form)
    swapform = form.dup
    swapform[0,1] = swapform[0,1].swapcase
    
    Lexeme.find(:all, :joins => :headwords, :conditions => ["headwords.form = ? OR headwords.form = ?", form, swapform])
  end
end
