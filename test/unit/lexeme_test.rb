require File.dirname(__FILE__) + '/../test_helper'

class LexemeTest < ActiveSupport::TestCase
  def test_lookup_all_by_headword_handles_wildcards
    contains_i = Lexeme.lookup_all_by_headword("i", :matchtype => Lexeme::SUBSTRING)
    assert contains_i.include?(Lexeme.lookup_by_headword("liter")), "does not catch 'liter'"
    assert contains_i.include?(Lexeme.lookup_by_headword("spring")), "does not catch 'spring'"
  end
  
  # Multiple headwords in one lexeme matching the substring should not return it more than once  
  def test_lookup_all_by_headword_removes_duplicates
    results = Lexeme.lookup_all_by_headword("lit", :matchtype => Lexeme::SUBSTRING)
    
    assert results.any? {|lexeme| lexeme.headword_forms.count {|form| form =~ /lit/ } > 1 }, 
      "For this test there needs to be a lexeme with multiple headwords matching the pattern"

    assert_equal results, results.uniq,
      "lookup_all_by_headword should remove duplicates in substring search"
  end
end
