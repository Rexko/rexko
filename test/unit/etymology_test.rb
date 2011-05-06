require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

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
  
  test "ancestor_map" do 
    assert_equal Hash[etymologies(:chained_A) => {etymologies(:chained_A2) => {}}],
      etymologies(:chained_A).ancestor_map
  end
  
  test "ancestor_map with next_etymon" do
    assert_equal [{etymologies(:with_same_language_next) => {}}, {etymologies(:with_same_language_next_b) => {}}], etymologies(:with_same_language_next).ancestor_map
  end
end
