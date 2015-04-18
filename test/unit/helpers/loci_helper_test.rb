require 'test_helper'

class LociHelperTest < ActionView::TestCase
  def test_sense_select
    probandum = parses(:literal).potential_interpretations
    
    assert_equal([["Test dictionary: literal, -alis (adj.)", [["First sense", 1], ["Second sense", 2], [I18n.t('helpers.loci.new_sense', lang: ""), "new-1"]]]], sense_select(probandum), 
      "sense_select does not return expected array")
  end
  
  test "sense select handles null dictionary" do
    probandum = parses(:parse_without_dictionary).potential_interpretations
    
    assert_equal [["(No dictionary): ----- (none)", [["A series of dashes.", 10], [I18n.t('helpers.loci.new_sense', lang: ""), "new-10"]]]], sense_select(probandum)
  end
end