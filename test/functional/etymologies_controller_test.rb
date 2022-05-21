# frozen_string_literal: true

require File.expand_path("#{File.dirname(__FILE__)}/../test_helper")

class EtymologiesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:etymologies)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_etymology
    assert_difference('Etymology.count') do
      post :create, params: { etymology: { etymon: 'test' } }
    end

    assert_redirected_to etymology_path(assigns(:etymology))
  end

  def test_should_show_etymology
    get :show, params: { id: etymologies(:one).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, params: { id: etymologies(:one).id }
    assert_response :success
  end

  def test_should_update_etymology
    put :update, params: { id: etymologies(:one).id, etymology: {} }
    assert_redirected_to etymology_path(assigns(:etymology))
  end

  def test_should_destroy_etymology
    assert_difference('Etymology.count', -1) do
      delete :destroy, params: { id: etymologies(:one).id }
    end

    assert_redirected_to etymologies_path
  end
end
