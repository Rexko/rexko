class Source < ActiveRecord::Base
  has_many :loci
  belongs_to :authorship #, :include => [:title, :author]
  delegate :title, :to => '(authorship or return nil)'
  delegate :author, :to => '(authorship or return nil)'
  # => would be nice:
  # has_one :title, "through" => :authorship
  # has_one :author, "through" => :authorship  
end
