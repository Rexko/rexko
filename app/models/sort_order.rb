class SortOrder < ActiveRecord::Base
  belongs_to :language
  serialize :substitutions, Hash
  serialize :orderings, Hash
  
  DEFAULT = new(substitutions: {}, orderings: {})
  
  def substitutions
    read_attribute(:substitutions) || {}
  end
  
  def orderings
    read_attribute(:orderings) || {}
  end
end
