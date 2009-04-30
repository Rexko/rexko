require File.dirname(__FILE__) + '/../test_helper'

class LexemesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:lexemes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_lexeme
    assert_difference('Lexeme.count') do
      post :create, :lexeme => { }
    end

    assert_redirected_to lexeme_path(assigns(:lexeme))
  end

  def test_should_show_lexeme
    get :show, :id => lexemes(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => lexemes(:one).id
    assert_response :success
  end

  def test_should_update_lexeme
    put :update, :id => lexemes(:one).id, :lexeme => { }
    assert_redirected_to lexeme_path(assigns(:lexeme))
  end

  def test_should_destroy_lexeme
    assert_difference('Lexeme.count', -1) do
      delete :destroy, :id => lexemes(:one).id
    end

    assert_redirected_to lexemes_path
  end
end
