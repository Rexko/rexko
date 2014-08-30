require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  def test_unwikify
    assert_equal("Unwikification of <b>bolded</b> text", wh("Unwikification of '''bolded''' text"), "#wh doesn't bold text in '''quote marks'''")
    
    assert_equal("Multiple <b>items</b> appearing in <b>bold</b>", wh("Multiple '''items''' appearing in '''bold'''"), "#wh doesn't handle multiple '''bold marks''' correctly")
    
    assert_equal("link to <a href=\"/html/text\" title=\"text\">text</a>", wh("link to [[text]]"), "#wh doesn't handle [[links]]")
    
    assert_equal("Unwikification of <i>italic</i> text", wh("Unwikification of ''italic'' text"), "#wh doesn't handle ''italics''")
    
    assert_equal("pipe <a href=\"/html/link\" title=\"link\">links</a>", wh("pipe [[link|links]]"), "#wh doesn't handle pipe [[link|links]]")
    
    assert_equal("in-word <a href=\"/html/link\" title=\"link\">links</a>", wh("in-word [[link]]s"), "#wh doesn't handle in-word [[link]]s")
    
    assert_equal("<a href=\"/html/in\" title=\"in\">in</a> <a href=\"/html/hostis\" title=\"hostis\">hostium</a>", wh("[[in]] [[hostis|hostium]]"), "#wh has an issue with multiple links")
  end
  
  def test_headword_link
    assert_equal "<a href=\"/en/lexemes/1\"><span class='hw-link'>liter</span></a>", headword_link(Parse.new(:parsed_form => "liter")), "headword_link does not return expected format for link to existing lexeme"
    
    assert_equal "<a href=\"/en/html/unattested\"><span class='hw-link'>#{t('lexeme.no_entry_linktext', headword: 'unattested', count: 0)}</span></a>", headword_link(Parse.new(:parsed_form => "unattested")), "headword_link does not return expected format for link to new lexeme"
  end
  
  def test_new_headword_link
    assert_equal "<a href=\"/html/unattested\"><span class='hw-link'>[No entry for <i>unattested</i> &times;0]</span></a>", new_headword_link(Parse.new(:parsed_form => "unattested")), "new_headword_link does not return expected format for link to new lexeme"
  end
  
  test "headword link is initial case insensitive" do
    # without @headwords
    assert_equal "<a href=\"/en/lexemes/1\"><span class='hw-link'>Liter</span></a>", headword_link(Parse.new(:parsed_form => "Liter"))
    
    # with @headwords
    @headwords = { "Liter" => headwords(:liter) }
    assert_equal "<a href=\"/en/lexemes/1\"><span class='hw-link'>Liter</span></a>", headword_link(Parse.new(:parsed_form => "Liter"))
  end
  
  test "sentence case" do
    assert_equal "Some English text", sentence_case("some English text")
  end
end
