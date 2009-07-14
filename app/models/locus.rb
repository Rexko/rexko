class Locus < ActiveRecord::Base
  belongs_to :source
  has_many :attestations
  has_many :parses, :through => :attestations

    accepts_nested_attributes_for :attestations, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }

  def most_wanted_parse
    parses.without_entries.max{|a, b| 
      Parse.count(:conditions => {:parsed_form => a.parsed_form}) <=> Parse.count(:conditions => {:parsed_form => b.parsed_form})
    }
  end
end
