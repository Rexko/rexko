require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class LociControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:loci)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_locus
    assert_difference('Locus.count') do
      post :create, :locus => { :example => "" }, :authorship => { :title_id => "", :author_id => "" }, :new_title => {:name => "Eggs"}, :new_author => {:name => "Bacon"}
    end

    assert_redirected_to locus_path(assigns(:locus))
  end

  def test_should_show_locus
    get :show, :id => loci(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => loci(:one).id
    assert_response :success
  end

  def test_should_update_locus
    put :update, :id => loci(:one).id, :locus => { :example => "" }, :authorship => { :title_id => "", :author_id => "" }, :new_title => {:name => "Eggs"}, :new_author => {:name => "Bacon"}
    assert_redirected_to locus_path(assigns(:locus))
  end

  def test_should_destroy_locus
    assert_difference('Locus.count', -1) do
      delete :destroy, :id => loci(:one).id
    end

    assert_redirected_to loci_path
  end
  
  test "@headwords should be initial case insensitive" do
    get :edit, :id => loci(:wrong_case_locus)

    heads = assigns(:headwords)
    
    assert_not_nil heads["Liter"], "failed to find a lexeme for 'Liter'. @headwords = #{heads}"
  end
end
