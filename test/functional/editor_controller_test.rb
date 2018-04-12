require 'test_helper'

class EditorControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should contain section links" do
    get :index
    assert_select "a[href=?]", languages_path
    assert_select "a[href=?]", dictionaries_path
    assert_select "a[href=?]", lexemes_path
    assert_select "a[href=?]", loci_path
  end
end
