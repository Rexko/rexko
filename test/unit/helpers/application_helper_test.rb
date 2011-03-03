require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  def test_unwikify
    assert_equal("Unwikification of <b>bolded</b> text", wh("Unwikification of '''bolded''' text"), "#wh doesn't bold text in '''quote marks'''")
    
    assert_equal("Multiple <b>items</b> appearing in <b>bold</b>", wh("Multiple '''items''' appearing in '''bold'''"), "#wh doesn't handle multiple '''bold marks''' correctly")
    
    assert_equal("link to <a href=\"/html/text\">text</a>", wh("link to [[text]]"), "#wh doesn't handle [[links]]")
    
    assert_equal("Unwikification of <i>italic</i> text", wh("Unwikification of ''italic'' text"), "#wh doesn't handle ''italics''")
    
    assert_equal("pipe <a href=\"/html/link\">links</a>", wh("pipe [[link|links]]"), "#wh doesn't handle pipe [[link|links]]")
    
    assert_equal("in-word <a href=\"/html/link\">links</a>", wh("in-word [[link]]s"), "#wh doesn't handle in-word [[link]]s")
    
    assert_equal("<a href=\"/html/in\">in</a> <a href=\"/html/hostis\">hostium</a>", wh("[[in]] [[hostis|hostium]]"), "#wh has an issue with multiple links")
  end
end
