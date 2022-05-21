# frozen_string_literal: true

require File.expand_path("#{File.dirname(__FILE__)}/../test_helper")

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
      post :create, params: { dictionary: { title: 'A test dictionary' } }
    end

    assert_redirected_to dictionary_path(assigns(:dictionary))
  end

  def test_should_show_dictionary
    get :show, params: { id: dictionaries(:one).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, params: { id: dictionaries(:one).id }
    assert_response :success
  end

  def test_should_update_dictionary
    put :update, params: { id: dictionaries(:one).id, dictionary: { title: 'A test dictionary' } }
    assert_redirected_to dictionary_path(assigns(:dictionary))
  end

  def test_should_destroy_dictionary
    assert_difference('Dictionary.count', -1) do
      delete :destroy, params: { id: dictionaries(:one).id }
    end

    assert_redirected_to dictionaries_path
  end

  # 82
  test 'should be able to edit external address' do
    get :edit, params: { id: dictionaries(:one).id }
    assert_select 'input[name=?]', 'dictionary[external_address]'
  end
end
