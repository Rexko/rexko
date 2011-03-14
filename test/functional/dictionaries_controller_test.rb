require File.dirname(__FILE__) + '/../test_helper'

class DictionariesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:dictionaries)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_dictionary
    assert_difference('Dictionary.count') do
      post :create, :dictionary => { :title => "Test dictionary"}
    end

    assert_redirected_to dictionary_path(assigns(:dictionary))
  end

  def test_should_show_dictionary
    get :show, :id => dictionaries(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => dictionaries(:one).id
    assert_response :success
  end

  def test_should_update_dictionary
    put :update, :id => dictionaries(:one).id, :dictionary => { :title => "Test dictionary" }
    assert_redirected_to dictionary_path(assigns(:dictionary))
  end

  def test_should_destroy_dictionary
    assert_difference('Dictionary.count', -1) do
      delete :destroy, :id => dictionaries(:one).id
    end

    assert_redirected_to dictionaries_path
  end
end
