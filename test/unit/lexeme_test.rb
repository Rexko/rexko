require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

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
  
  test "lookup_all_by_headwords" do
    results = Lexeme.lookup_all_by_headwords(["liter", "spring"])
    
    assert results.include?(lexemes(:liter_lex)) && 
           results.include?(lexemes(:spring_a)) && 
           results.include?(lexemes(:spring_b)), "does not return all expected lexemes; returned #{results}"
  end
  
  test "lookup_all_by_headwords ignores initial case" do
    results = Lexeme.lookup_all_by_headwords(["Liter", "Spring"])

    assert results.include?(lexemes(:liter_lex)) && 
           results.include?(lexemes(:spring_a)) && 
           results.include?(lexemes(:spring_b)), "does not ignore initial case; returned #{results}"    
  end
  
  test "language" do
    assert lexemes(:literal).respond_to?(:language), "lexeme should respond to #language"
    assert_equal languages(:testwegian), lexemes(:literal).language
    assert_equal "und", lexemes(:lexeme_without_dictionary).language.name
  end
  
  test "constructions" do
    constructions = lexemes(:appearing_in_construction_a).constructions
    assert constructions.include?(lexemes(:with_construction)), "#{constructions} does not include #{lexemes(:with_construction)}"
  end
  
  test "attested_by" do
    assert Lexeme.respond_to?(:attested_by), "should respond to :attested_by"
    results = Lexeme.attested_by(attestations(:with_constructions), "Attestation")
    
    assert results.include?(lexemes(:with_construction)), "#{results} does not include #{lexemes(:with_construction)}"
  end
end
