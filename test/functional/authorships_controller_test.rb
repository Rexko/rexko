require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class AuthorshipsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:authorships)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_authorship
    assert_difference('Authorship.count') do
      post :create, :authorship => { }
    end

    assert_redirected_to authorship_path(assigns(:authorship))
  end

  def test_should_show_authorship
    get :show, :id => authorships(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => authorships(:one).id
    assert_response :success
  end

  def test_should_update_authorship
    put :update, :id => authorships(:one).id, :authorship => { }
    assert_redirected_to authorship_path(assigns(:authorship))
  end

  def test_should_destroy_authorship
    assert_difference('Authorship.count', -1) do
      delete :destroy, :id => authorships(:one).id
    end

    assert_redirected_to authorships_path
  end
end
