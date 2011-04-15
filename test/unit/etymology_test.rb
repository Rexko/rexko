require File.dirname(__FILE__) + '/../test_helper'

class EtymologyTest < ActiveSupport::TestCase
  test "primary_gloss" do
    assert_equal "one", etymologies(:simple).primary_gloss, "Etymology should return its own gloss if present"
    assert_equal "30", etymologies(:with_parse).primary_gloss
  end
  
  test "should ignore blank subetymon" do
    etym = Etymology.new
    subetym = Etymology.new
    etym.attributes = { :etymon => "an" }
    etym.next_etymon_attributes = subetym.attributes
    
    assert etym.valid?, "should ignore blank subetymon but reports #{etym.errors.full_messages}"
  end
  
  test "primary_parent" do
    assert_equal etymologies(:chained_A2), etymologies(:chained_A).primary_parent
  end
end
