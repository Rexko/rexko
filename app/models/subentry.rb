class Subentry < ActiveRecord::Base
  has_many :etymotheses
  has_many :etymologies, :through => :etymotheses
  belongs_to :lexeme
  belongs_to :language
  has_many :senses
  validates_presence_of :paradigm
  
  accepts_nested_attributes_for :senses, :etymologies, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
end
