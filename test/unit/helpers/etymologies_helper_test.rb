require 'test_helper'

class EtymologiesHelperTest < ActionView::TestCase
  include ApplicationHelper
  
  test "html_format" do
    assert_equal "<span class=\"lexform-source-language\">Latin</span> <span class=\"lexform-etymon\">unum</span> <span class=\"lexform-etymon-gloss\">one</span>.",
      html_format(etymologies(:simple))
  end
  
  test "html_format with nested etyma" do
    assert_equal "<span class=\"lexform-source-language\">Latin</span> <span class=\"lexform-etymon\">unus</span> <span class=\"lexform-etymon-gloss\">one</span> + <span class=\"lexform-etymon\">cornu</span> <span class=\"lexform-etymon-gloss\">horn</span>.", 
      html_format(etymologies(:with_same_language_next))
  end
end