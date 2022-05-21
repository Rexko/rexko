require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class DictionaryScopesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:dictionary_scopes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_dictionary_scope
    assert_difference('DictionaryScope.count') do
      post :create, params: { dictionary_scope: dictionary_scopes(:one).attributes }
    end

    assert_redirected_to dictionary_scope_path(assigns(:dictionary_scope))
  end

  def test_should_show_dictionary_scope
    get :show, params: { id: dictionary_scopes(:one).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, params: { id: dictionary_scopes(:one).id }
    assert_response :success
  end

  def test_should_update_dictionary_scope
    put :update, params: { id: dictionary_scopes(:one).id, dictionary_scope: {} }
    assert_redirected_to dictionary_scope_path(assigns(:dictionary_scope))
  end

  def test_should_destroy_dictionary_scope
    assert_difference('DictionaryScope.count', -1) do
      delete :destroy, params: { id: dictionary_scopes(:one).id }
    end

    assert_redirected_to dictionary_scopes_path
  end
end
