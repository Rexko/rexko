class Sense < ActiveRecord::Base
  belongs_to :subentry
  delegate :lexeme, :to => '(subentry or return nil)' 
  belongs_to :language
  has_many :glosses
  has_many :interpretations
  has_many :parses, :through => :interpretations
  has_many :notes, :as => :annotatable
  validate :validate_sufficient_data
  
  accepts_nested_attributes_for :glosses, :parses, :notes, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
  
  HASH_MAP_TO_PARSE = { :interpretations => Interpretation::HASH_MAP_TO_PARSE }
  
  def self.lookup_all_by_headword(form)
    swapform = form.dup
    swapform[0,1] = swapform[0,1].swapcase
    
    Sense.find(:all, :joins => [{ :subentry => { :lexeme => :headwords} } ], :conditions => ["headwords.form = ? OR headwords.form = ?", form, swapform])
  end
  
protected
  def validate_sufficient_data
    if definition.blank? && glosses.empty?
      errors.add_to_base("Definition or gloss must be supplied for a sense") 
    end
  end
end
