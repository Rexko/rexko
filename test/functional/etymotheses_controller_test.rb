require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class EtymothesesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:etymotheses)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_etymothesis
    assert_difference('Etymothesis.count') do
      post :create, params: { etymothesis: {} }
    end

    assert_redirected_to etymothesis_path(assigns(:etymothesis))
  end

  def test_should_show_etymothesis
    get :show, params: { id: etymotheses(:one).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, params: { id: etymotheses(:one).id }
    assert_response :success
  end

  def test_should_update_etymothesis
    put :update, params: { id: etymotheses(:one).id, etymothesis: {} }
    assert_redirected_to etymothesis_path(assigns(:etymothesis))
  end

  def test_should_destroy_etymothesis
    assert_difference('Etymothesis.count', -1) do
      delete :destroy, params: { id: etymotheses(:one).id }
    end

    assert_redirected_to etymotheses_path
  end
end
