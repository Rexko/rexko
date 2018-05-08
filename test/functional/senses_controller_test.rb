require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class SensesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:senses)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_sense
    assert_difference('Sense.count') do
      post :create, params: { :sense => { :definition => "text"} }
    end

    assert_redirected_to sense_path(assigns(:sense))
  end

  def test_should_show_sense
    get :show, params: { :id => senses(:one).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, params: { :id => senses(:one).id }
    assert_response :success
  end

  def test_should_update_sense
    put :update, params: { :id => senses(:one).id, :sense => { :definition => "test"} }
    assert_redirected_to sense_path(assigns(:sense))
  end

  def test_should_destroy_sense
    assert_difference('Sense.count', -1) do
      delete :destroy, params: { :id => senses(:one).id }
    end

    assert_redirected_to senses_path
  end
end
