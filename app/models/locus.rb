class Locus < ActiveRecord::Base
  belongs_to :source
  has_many :attestations
  has_many :parses, :through => :attestations

  named_scope :attesting, lambda { |lexeme|
    { :joins => { :attestations => { :parses => { :interpretations => { :sense => :subentry }}}},
    :conditions => { :subentries => { :lexeme_id => [*lexeme].collect(&:id) }} }
  }

  accepts_nested_attributes_for :attestations, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }

  # Returns the parse with the most attestations that doesn't have an entry yet. 
  def most_wanted_parse
    parses.find(:first, :select => '"parses".id, "parses"."parsed_form", (SELECT COUNT("parsed_form") FROM "parses" s WHERE s."parsed_form" = "parses"."parsed_form") AS count_all', :joins => ['LEFT OUTER JOIN "headwords" ON "headwords"."form" = "parsed_form"'], :conditions => {:headwords => {:form => nil}}, :order => 'count_all DESC')
  end
end
