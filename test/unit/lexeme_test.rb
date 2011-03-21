require File.dirname(__FILE__) + '/../test_helper'

class LexemeTest < ActiveSupport::TestCase
  def test_lookup_all_by_headword_handles_wildcards
    contains_i = Lexeme.lookup_all_by_headword("i", :matchtype => Lexeme::SUBSTRING)
    assert contains_i.include?(Lexeme.lookup_by_headword("liter")), "does not catch 'liter'"
    assert contains_i.include?(Lexeme.lookup_by_headword("spring")), "does not catch 'spring'"
  end
end
