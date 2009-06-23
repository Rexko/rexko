class Locus < ActiveRecord::Base
  belongs_to :source
  has_many :attestations
  has_many :parses, :through => :attestations

    accepts_nested_attributes_for :attestations, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }

end
