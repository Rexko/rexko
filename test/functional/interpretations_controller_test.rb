require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class InterpretationsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:interpretations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_interpretation
    assert_difference('Interpretation.count') do
      post :create, :interpretation => { :sense_attributes => { :definition => "First sense" }}
    end

    assert_redirected_to interpretation_path(assigns(:interpretation))
  end

  def test_should_show_interpretation
    get :show, :id => interpretations(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => interpretations(:one).id
    assert_response :success
  end

  def test_should_update_interpretation
    put :update, :id => interpretations(:one).id, :interpretation => { :sense_attributes => { :definition => "First sense" }}
    assert_redirected_to interpretation_path(assigns(:interpretation))
  end

  def test_should_destroy_interpretation
    assert_difference('Interpretation.count', -1) do
      delete :destroy, :id => interpretations(:one).id
    end

    assert_redirected_to interpretations_path
  end
end
