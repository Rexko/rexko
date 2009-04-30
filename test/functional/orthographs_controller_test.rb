require File.dirname(__FILE__) + '/../test_helper'

class OrthographsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:orthographs)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_orthograph
    assert_difference('Orthograph.count') do
      post :create, :orthograph => { }
    end

    assert_redirected_to orthograph_path(assigns(:orthograph))
  end

  def test_should_show_orthograph
    get :show, :id => orthographs(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => orthographs(:one).id
    assert_response :success
  end

  def test_should_update_orthograph
    put :update, :id => orthographs(:one).id, :orthograph => { }
    assert_redirected_to orthograph_path(assigns(:orthograph))
  end

  def test_should_destroy_orthograph
    assert_difference('Orthograph.count', -1) do
      delete :destroy, :id => orthographs(:one).id
    end

    assert_redirected_to orthographs_path
  end
end
