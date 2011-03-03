require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  def test_unwikify
    assert_equal("Unwikification of <b>bolded</b> text", wh("Unwikification of '''bolded''' text"), "#wh doesn't bold text in '''quote marks'''")
    
    assert_equal("Multiple <b>items</b> appearing in <b>bold</b>", wh("Multiple '''items''' appearing in '''bold'''"), "#wh doesn't handle multiple '''bold marks''' correctly")
    
    assert_equal("link to <a href=\"/html/text\">text</a>", wh("link to [[text]]"), "#wh doesn't handle [[links]]")
    
    assert_equal("Unwikification of <i>italic</i> text", wh("Unwikification of ''italic'' text"), "#wh doesn't handle ''italics''")
  end
end
