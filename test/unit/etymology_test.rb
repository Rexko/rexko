require File.dirname(__FILE__) + '/../test_helper'

class EtymologyTest < ActiveSupport::TestCase
  test "primary_gloss" do
    assert_equal "one", etymologies(:simple).primary_gloss, "Etymology should return its own gloss if present"
    assert_equal "30", etymologies(:with_parse).primary_gloss
  end
end
