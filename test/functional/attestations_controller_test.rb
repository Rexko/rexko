require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class AttestationsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:attestations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_attestation
    assert_difference('Attestation.count') do
      post :create, params: { :attestation => { :attested_form => "test" } }
    end

    assert_redirected_to attestation_path(assigns(:attestation))
  end

  def test_should_show_attestation
    get :show, params: { :id => attestations(:one).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, params: { :id => attestations(:one).id }
    assert_response :success
  end

  def test_should_update_attestation
    put :update, params: { :id => attestations(:one).id, :attestation => { } }
    assert_redirected_to attestation_path(assigns(:attestation))
  end

  def test_should_destroy_attestation
    assert_difference('Attestation.count', -1) do
      delete :destroy, params: { :id => attestations(:one).id }
    end

    assert_redirected_to attestations_path
  end
end
