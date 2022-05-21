require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class HeadwordsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:headwords)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_headword
    assert_difference('Headword.count') do
      post :create, params: { headword: { form: 'test' } }
    end

    assert_redirected_to headword_path(assigns(:headword))
  end

  def test_should_show_headword
    get :show, params: { id: headwords(:one).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, params: { id: headwords(:one).id }
    assert_response :success
  end

  def test_should_update_headword
    put :update, params: { id: headwords(:one).id, headword: {} }
    assert_redirected_to headword_path(assigns(:headword))
  end

  def test_should_destroy_headword
    assert_difference('Headword.count', -1) do
      delete :destroy, params: { id: headwords(:one).id }
    end

    assert_redirected_to headwords_path
  end
end
