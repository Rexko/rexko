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
  
  test "wiki_format" do
    assert_equal html_escape("Latin unum \"one\"."), wiki_format(etymologies(:simple))
    assert_equal html_escape("Latin unus \"one\" + cornu \"horn\"."),
      wiki_format(etymologies(:with_same_language_next))
  end
  
  test "html and wiki formats with parses" do
    assert_equal html_escape("Spanish treinta \"30\"."), wiki_format(etymologies(:with_parse))
    assert_equal "<span class=\"lexform-source-language\">Spanish</span> <span class=\"lexform-etymon\">treinta</span> <span class=\"lexform-etymon-gloss\">30</span>.",
      html_format(etymologies(:with_parse))
  end
  
  test "html and wiki formats where etymon not associated with language" do
    assert_equal html_escape(":-) \"smile\"."), wiki_format(etymologies(:without_language))
    assert_equal "<span class=\"lexform-etymon\">:-)</span> <span class=\"lexform-etymon-gloss\">smile</span>.", 
      html_format(etymologies(:without_language))
  end
end