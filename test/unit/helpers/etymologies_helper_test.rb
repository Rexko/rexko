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
  
  test "chained etymologies" do
    assert_equal html_escape("1ary \"primary\", from 2ary."), wiki_format(etymologies(:chained_A))
    assert_equal html_escape("1ary A \"test\" + 1ary B \"test 2\"; where 1ary A is from 2ary A, and where 1ary B is from 2ary B."), wiki_format(etymologies(:chained_B))
#    assert_equal "X + Y; X, from Z, from B, and Y, from A, from C + D; C, from L, and D, also from A."
    assert_equal "X + Y; where X is from Z, from B, and where Y is from A, from C + D; where C is from L, and where D is also from A.", wiki_format(etymologies(:chained_C))
  end
end