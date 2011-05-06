require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ParsesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:parses)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_parse
    assert_difference('Parse.count') do
      post :create, :parse => { :parsed_form => "text"}
    end

    assert_redirected_to parse_path(assigns(:parse))
  end

  def test_should_show_parse
    get :show, :id => parses(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => parses(:one).id
    assert_response :success
  end

  def test_should_update_parse
    put :update, :id => parses(:one).id, :parse => { :parsed_form => "test" }
    assert_redirected_to parse_path(assigns(:parse))
  end

  def test_should_destroy_parse
    assert_difference('Parse.count', -1) do
      delete :destroy, :id => parses(:one).id
    end

    assert_redirected_to parses_path
  end
end
