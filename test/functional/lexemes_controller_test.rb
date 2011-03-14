require File.dirname(__FILE__) + '/../test_helper'

class LexemesControllerTest < ActionController::TestCase
  fixtures :lexemes, :headwords, :parses, :loci, :interpretations, :senses, :subentries
  def setup
    associations = {
      lexemes(:liter) => {  lexemes(:liter).subentries => subentries(:one),
                            lexemes(:liter).headwords => headwords(:one)},
      parses(:liters) => {parses(:liters).interpretations => interpretations(:one)},
      parses(:litres) => {parses(:litres).interpretations => interpretations(:two)},
      attestations(:nat_liters) => {attestations(:nat_liters).parses => parses(:liters)},
      attestations(:nem_litres) => {attestations(:nem_litres).parses => parses(:litres)},
      loci(:natvilcius) => {loci(:natvilcius).attestations => attestations(:nat_liters)},
      loci(:nemo) => {loci(:nemo).attestations => attestations(:nem_litres)}
    }
    
    associations.each do |record, assoc|
      assoc.each do |collection, val|
        collection << val
      end
      record.save
    end

#    lexemes(:liter).subentries << subentries(:one)
#    lexemes(:liter).headwords << headwords(:one)
#    lexemes(:liter).save
    
#    parses(:liters).interpretations << interpretations(:one)
#    parses(:liters).save
#    parses(:litres).interpretations << interpretations(:two)
#    parses(:litres).save
    
#    attestations(:nat_liters).parses << parses(:liters)
#    attestations(:nat_liters).save
#    attestations(:nem_litres).parses << parses(:litres)
#    attestations(:nem_litres).save
    
#    loci(:natvilcius).attestations << attestations(:nat_liters)
#    loci(:natvilcius).save
#    loci(:nemo).attestations << attestations(:nem_litres)
#    loci(:nemo).save
  end
  
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
  
  def test_fixture_should_set_up_correctly
    assert lexemes(:liter).headwords.count > 0, "Test fixture should have more than zero headwords"
    assert loci(:nemo).attests?("litre"), "Fixture loci(:nemo) should attest 'litre'."
    assert Locus.attesting(lexemes(:liter)).count > 0, "Loci should attest the 'liter' lexeme."

    assert lexemes(:liter).loci.count > 0, "Test fixture does not have any loci for further tests"    
  end
  
  # 'show' should create a @loci_for hash that breaks out constructions by 
  # headword form.
  def test_should_assign_loci_for
    get :show, :id => lexemes(:liter).id
    
    loci_for = assigns(:loci_for)
    
    assert_not_nil loci_for
    
    lexemes(:liter).headword_forms.each do |headword|
      assert loci_for.has_key?(headword), "@loci_for hash should have a key for #{headword}"
      loci_for.each do |hw, loci|
        loci.each do |locus| 
          assert locus.attests?(hw), "construction in @loci_for[#{headword}] doesn't attest #{hw}"
        end
      end
    end
  end
end
