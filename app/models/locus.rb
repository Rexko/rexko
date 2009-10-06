class Locus < ActiveRecord::Base
  belongs_to :source
  has_many :attestations
  has_many :parses, :through => :attestations

  named_scope :attesting, lambda { |lexeme|
    { :joins => { :attestations => { :parses => { :interpretations => { :sense => :subentry }}}},
    :conditions => { :subentries => { :lexeme_id => [*lexeme].collect(&:id) }} }
  }

    accepts_nested_attributes_for :attestations, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }

  def most_wanted_parse
    parses.without_entries.sort_by{|parse|
      Parse.count(:conditions => {:parsed_form => parse.parsed_form})
    }.last
  end
end
