require 'test_helper'

class EditorControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should contain section links" do
    get :index
    assert_tag :a, :attributes => { :href => languages_path }
    assert_tag :a, :attributes => { :href => dictionaries_path }
    assert_tag :a, :attributes => { :href => lexemes_path }
    assert_tag :a, :attributes => { :href => loci_path }
  end
end
