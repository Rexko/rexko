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
    assert_equal "#{SOURCE_LANG % "Latin"} #{ETYMON % "unus"} #{GLOSS % "one"} + #{ETYMON % "cornu"} #{GLOSS % "horn"} + #{SOURCE_LANG % "Testwegian"} #{ETYMON % "phobos"}.", 
      html_format(etymologies(:with_same_language_next))
  end
  
  test "wiki_format" do
    assert_equal html_escape("Latin unum \"one\"."), wiki_format(etymologies(:simple))
    assert_equal html_escape("Latin unus \"one\" + cornu \"horn\" + Testwegian phobos."),
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

    assert_equal "#{SOURCE_LANG % "Latin"} #{ETYMON % "unus"} #{GLOSS % "one"} + #{ETYMON % "cornu"} #{GLOSS % "horn"} + #{SOURCE_LANG % "Testwegian"} #{ETYMON % "phobos"}.", 
      html_format(etymologies(:with_same_language_next))
		assert_equal html_escape("Latin unus \"one\" + cornu \"horn\" + Testwegian phobos."),
			wiki_format(etymologies(:with_same_language_next))
	end
	
	# Was returning:
	# [abdo + do; where abdo is from ab, from Proto-Indo-European *apo, and where do is from Proto-Indo-European *dH3-.]
	# Should be returning:
	# [abdo; from ab + do, where ab is from Proto-Indo-European *apo, and where do is from Proto-Indo-European *dH3-..]
	test "issue #117 - anomalous output" do
		words = [[:abdomen, :abdo], [:abdo, [:ab, :do]], [:ab, :apo], [:do, :dh3], [:apo], [:dh3]]
		subentries = {}
		
		words.each do |word|
			subentries[word[0]] = Subentry.create!(:paradigm => word[0].to_s)
			subentries[word[0]].senses.create(:definition => word[0].to_s)
		end
		words.each do |word|
			cur = subentries[word[0]]
			if word.shift
				if word[0].is_a? Array
					next_etym = Etymology.create!(:etymon => word[0][1].to_s)
					pars = next_etym.parses.create(:parsed_form => word[0][1].to_s)
					terp = pars.interpretations.create(:sense => subentries[word[0][1]].senses.first)

					etym = cur.etymologies.create(:etymon => word[0][0].to_s, :next_etymon => next_etym)
					pars = etym.parses.create(:parsed_form => word[0][0].to_s)
					terp = pars.interpretations.create(:sense => subentries[word[0][0]].senses.first)
				else 
					unless word.blank?
						etym = cur.etymologies.create!(:etymon => word[0].to_s)
						pars = etym.parses.create(:parsed_form => word[0].to_s)
						terp = pars.interpretations.create(:sense => subentries[word[0]].senses.first)
					end
				end
			end
		end

    assert_equal "#{ETYMON % "abdo"}, from #{ETYMON % "ab"} + #{ETYMON % "do"}; where #{ETYMON % "ab"} is from #{ETYMON % "apo"}, and where #{ETYMON % "do"} is from #{ETYMON % "dh3"}.", 
      html_format(subentries[:abdomen].etymologies.first)  	
		assert_equal html_escape("abdo, from ab + do; where ab is from apo, and where do is from dh3."),
			wiki_format(subentries[:abdomen].etymologies.first)
	end
end