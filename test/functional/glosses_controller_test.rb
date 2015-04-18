require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class GlossesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:glosses)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_gloss
    assert_difference('Gloss.count') do
      post :create, { gloss: { gloss_en: "test" }, locale: :en }
    end

    assert_redirected_to gloss_path(assigns(:gloss))
  end

  def test_should_show_gloss
    get :show, :id => glosses(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => glosses(:one).id
    assert_response :success
  end

  def test_should_update_gloss
    put :update, :id => glosses(:one).id, :gloss => { }
    assert_redirected_to gloss_path(assigns(:gloss))
  end

  def test_should_destroy_gloss
    assert_difference('Gloss.count', -1) do
      delete :destroy, :id => glosses(:one).id
    end

    assert_redirected_to glosses_path
  end
end
