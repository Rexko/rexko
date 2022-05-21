require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class SubentriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:subentries)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_subentry
    assert_difference('Subentry.count') do
      post :create, params: { subentry: { paradigm: 'test, tests' } }
    end

    assert_redirected_to subentry_path(assigns(:subentry))
  end

  def test_should_show_subentry
    get :show, params: { id: subentries(:one).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, params: { id: subentries(:one).id }
    assert_response :success
  end

  def test_should_update_subentry
    put :update, params: { id: subentries(:one).id, subentry: {} }
    assert_redirected_to subentry_path(assigns(:subentry))
  end

  def test_should_destroy_subentry
    assert_difference('Subentry.count', -1) do
      delete :destroy, params: { id: subentries(:one).id }
    end

    assert_redirected_to subentries_path
  end
end
