require File.dirname(__FILE__) + '/../test_helper'

class TitlesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:titles)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_title
    assert_difference('Title.count') do
      post :create, :title => { }
    end

    assert_redirected_to title_path(assigns(:title))
  end

  def test_should_show_title
    get :show, :id => titles(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => titles(:one).id
    assert_response :success
  end

  def test_should_update_title
    put :update, :id => titles(:one).id, :title => { }
    assert_redirected_to title_path(assigns(:title))
  end

  def test_should_destroy_title
    assert_difference('Title.count', -1) do
      delete :destroy, :id => titles(:one).id
    end

    assert_redirected_to titles_path
  end
end
