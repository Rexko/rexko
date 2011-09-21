require 'test_helper'

class EtymologiesHelperTest < ActionView::TestCase
  include ApplicationHelper
  SOURCE_LANG = "<span class=\"lexform-source-language\">%s</span>"
  ETYMON = "<span class=\"lexform-etymon\">%s</span>"
  GLOSS = "<span class=\"lexform-etymon-gloss\">%s</span>"
  
  test "html_format" do
    assert_equal "#{SOURCE_LANG % "Latin"} #{ETYMON % "unum"} #{GLOSS % "one"}.",
      html_format(etymologies(:simple))
  end
  
  test "html_format with nested etyma" do
    assert_equal "#{SOURCE_LANG % "Latin"} #{ETYMON % "unus"} #{GLOSS % "one"} + #{ETYMON % "cornu"} #{GLOSS % "horn"}.", 
      html_format(etymologies(:with_same_language_next))
  end
  
  test "wiki_format" do
    assert_equal html_escape("Latin unum \"one\"."), wiki_format(etymologies(:simple))
    assert_equal html_escape("Latin unus \"one\" + cornu \"horn\"."),
      wiki_format(etymologies(:with_same_language_next))
  end
  
  test "html and wiki formats with parses" do
    assert_equal html_escape("Spanish treinta \"30\"."), wiki_format(etymologies(:with_parse))
    assert_equal "#{SOURCE_LANG % "Spanish"} #{ETYMON % "treinta"} #{GLOSS % "30"}.",
      html_format(etymologies(:with_parse))
  end
  
  test "html and wiki formats where etymon not associated with language" do
    assert_equal html_escape(":-) \"smile\"."), wiki_format(etymologies(:without_language))
    assert_equal "#{ETYMON % ":-)"} #{GLOSS % "smile"}.", 
      html_format(etymologies(:without_language))
  end
  
  test "chained etymologies, simple case" do
    assert_equal html_escape("1ary \"primary\", from 2ary."), wiki_format(etymologies(:chained_A))
    assert_equal "#{ETYMON % "1ary"} #{GLOSS % "primary"}, from #{ETYMON % "2ary"}.", html_format(etymologies(:chained_A))
  end
  
  test "chained etymologies, compound case" do
    assert_equal html_escape("1ary A \"test\" + 1ary B \"test 2\"; where 1ary A is from 2ary A, and where 1ary B is from 2ary B."), wiki_format(etymologies(:chained_B))
    assert_equal "#{ETYMON % "1ary A"} #{GLOSS % "test"} + #{ETYMON % "1ary B"} #{GLOSS % "test 2"}; where #{ETYMON % "1ary A"} is from #{ETYMON % "2ary A"}, and where #{ETYMON % "1ary B"} is from #{ETYMON % "2ary B"}.", html_format(etymologies(:chained_B))
  end
  
  test "more than two etyma" do
  	etym = etymologies(:with_same_language_next)
  	new_etym = Etymology.create({:etymon => "phobos", :gloss => "fear", :original_language => languages(:latin)})
  	etymologies(:with_same_language_next_b).next_etymon = new_etym

		assert_equal new_etym, etymologies(:with_same_language_next_b).next_etymon

    assert_equal "#{SOURCE_LANG % "Latin"} #{ETYMON % "unus"} #{GLOSS % "one"} + #{ETYMON % "cornu"} #{GLOSS % "horn"} + #{ETYMON % "phobos"} #{GLOSS % "fear"}.", 
      html_format(etymologies(:with_same_language_next))  	
		assert_equal html_escape("Latin unus \"one\" + cornu \"horn\" + phobos \"fear\""),
			wiki_format(etymologies(:with_same_language_next))
	end
end