class SortOrder < ActiveRecord::Base
  belongs_to :language
  serialize :substitutions, Hash
  serialize :orderings, Hash
  validate :attrs_are_hashes
  
  DEFAULT = new(substitutions: {}, orderings: {})
  
  def substitutions
    read_attribute(:substitutions) || {}
  end

  def substitutions=(attributes)
    if attributes.is_a? String
      attributes = attributes.split("\n").inject({}) do |memo, obj|
        orig, xform = obj.split("\s", 2)
        memo[orig] = xform
        memo 
      end
    end
    write_attribute(:substitutions, attributes)
  end
  
  def orderings
    read_attribute(:orderings) || {}
  end

  def orderings=(attributes)
    if attributes.is_a? String
      attributes = attributes.split("\n").inject({}) do |memo, obj|
        former, latter = obj.split("\s", 2)
        memo[latter] = former
        memo 
      end
    end
    write_attribute(:orderings, attributes)
  end

protected
  def attrs_are_hashes
    substitutions.is_a?(Hash) && orderings.is_a?(Hash)
  end
end
