require 'test_helper'

class LociHelperTest < ActionView::TestCase
  def test_optgroups
    probandum = parses(:literal).potential_interpretations
    
    assert_equal([["Test dictionary: literal, -alis (adj.)", [["First sense", 1], ["Second sense", 2]]]], sense_select(probandum), 
      "sense_select_hash does not return expected array")
  end
end