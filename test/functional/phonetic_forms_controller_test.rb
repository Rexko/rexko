require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class PhoneticFormsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:phonetic_forms)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_phonetic_form
    assert_difference('PhoneticForm.count') do
      post :create, params: { phonetic_form: { form: '[beIk@n]' } }
    end

    assert_redirected_to phonetic_form_path(assigns(:phonetic_form))
  end

  def test_should_show_phonetic_form
    get :show, params: { id: phonetic_forms(:one).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, params: { id: phonetic_forms(:one).id }
    assert_response :success
  end

  def test_should_update_phonetic_form
    put :update, params: { id: phonetic_forms(:one).id, phonetic_form: { form: '[Egz]' } }
    assert_redirected_to phonetic_form_path(assigns(:phonetic_form))
  end

  def test_should_destroy_phonetic_form
    assert_difference('PhoneticForm.count', -1) do
      delete :destroy, params: { id: phonetic_forms(:one).id }
    end

    assert_redirected_to phonetic_forms_path
  end
end
