class SortOrder < ApplicationRecord
  belongs_to :language
  serialize :substitutions, Hash
  serialize :orderings, Hash
  validate :attrs_are_hashes
  translates :name

  DEFAULT = new(substitutions: {}, orderings: {})

  def self.safe_params
    %i[substitutions orderings]
  end

  def substitutions
    read_attribute(:substitutions) || {}
  end

  def substitutions=(attributes)
    if attributes.is_a? String
      attributes = attributes.split(/\r?\n/).each_with_object({}) do |obj, memo|
        orig, xform = obj.split("\s", 2)
        memo[orig] = xform
      end
    end
    write_attribute(:substitutions, attributes)
  end

  def orderings
    read_attribute(:orderings) || {}
  end

  def orderings=(attributes)
    if attributes.is_a? String
      attributes = attributes.split(/\r?\n/).each_with_object({}) do |obj, memo|
        former, latter = obj.split("\s", 2)
        memo[latter] = former
      end
    end
    write_attribute(:orderings, attributes)
  end

  protected

  def attrs_are_hashes
    substitutions.is_a?(Hash) && orderings.is_a?(Hash)
  end
end
