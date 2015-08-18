require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

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
  
  def test_fixture_should_set_up_correctly
    assert lexemes(:liter_lex).headwords.count > 0, "Test fixture should have more than zero headwords"
    assert loci(:nemo).attests?("litre"), "Fixture loci(:nemo) should attest 'litre'."
    assert Locus.attesting(lexemes(:liter_lex)).all.count > 0, "Loci should attest the 'liter' lexeme."

    assert lexemes(:liter_lex).loci.all.count > 0, "Test fixture does not have any loci for further tests"    
  end
  
  # 'show' should create a @loci_for hash that breaks out constructions by 
  # headword form.
  def test_show_should_assign_loci_for
    get :show, :id => lexemes(:liter_lex).id
    
    loci_for = assigns(:loci_for)
    
    assert_not_nil loci_for
    
    lexemes(:liter_lex).headword_forms.each do |headword|
      assert loci_for.has_key?(headword), "@loci_for hash should have a key for #{headword}"
      loci_for.each do |hw, loci|
        loci.each do |locus| 
          assert locus.attests?(hw), "construction in @loci_for[#{headword}] doesn't attest #{hw}"
        end
      end
    end
  end
  
  def test_show_by_headword_can_return_multiple_results
    get :show_by_headword, :headword => "liter", :matchtype => Lexeme::EXACT
    
    lexeme = assigns(:lexeme)
    assert_not_nil lexeme, "Headword 'liter' should return a lexeme; 'liter's lexeme is #{Lexeme.lookup_by_headword('liter')}"
    assert_equal 1, lexeme.length, "Headword 'liter' should return only one lexeme"
    
    get :show_by_headword, :headword => "spring", :matchtype => Lexeme::EXACT
    
    lexeme = assigns(:lexeme)
    assert_not_nil lexeme, "Headword 'spring' should return a lexeme"
    assert lexeme.length > 1, "Headword 'spring' should return more than one lexeme"
  end
  
  def test_matching_uses_template
    get :matching, :headword => "spring", :matchtype => Lexeme::SUBSTRING
    
    assert_template "layouts/1col_layout"
  end
  
  def test_matching_sets_title
    get :matching, :headword => "spring", :matchtype => Lexeme::SUBSTRING
    
    title = assigns(:page_title)
    assert_not_nil title, "Show_by_headword should set a title"
    assert_equal "Lexemes - 2 results for \"spring\"", title
  end
  
  def test_show_by_headword_respects_match_type
    get :show_by_headword, :headword => "liter", :matchtype => Lexeme::SUBSTRING
    
    results = assigns(:lexeme)
    assert results.length > 1, 
      "Substring search for 'liter' found #{results.length}; there are at least two in the fixtures"
    
    get :show_by_headword, :headword => "liter", :matchtype => Lexeme::EXACT
    
    results = assigns(:lexeme)
    assert_equal 1, results.length,
      "Exact search for 'liter' found #{results.length}; there should only be one in the fixtures"
  end
  
  def test_substring_search_friendly_url
    assert_recognizes({:controller => "lexemes", :action => "matching", :headword => 'liter', :matchtype => Lexeme::SUBSTRING }, "/lexemes/matching/liter")
    
    get :show_by_headword, :headword => "liter", :matchtype => Lexeme::SUBSTRING
    
    assert_redirected_to "/en/lexemes/matching/liter"
  end
  
  test "don't fail if locus contains a construction that does not reference it" do
    blue = lexemes(:appearing_in_construction_a)
    blue_jay = lexemes(:with_construction)
    assert Lexeme.attested_by(loci(:with_constructions).attestations, "Attestation").include? blue_jay
    assert Lexeme.attested_by(loci(:with_constructions).attestations, "Attestation").include? blue
    assert Lexeme.attested_by(loci(:with_same_construction).attestations, "Attestation").include? blue_jay
    assert !Lexeme.attested_by(loci(:with_same_construction).attestations, "Attestation").include?(blue)  
      
    get :show, :id => lexemes(:appearing_in_construction_a).id
    assert_response :success
  end
    
  # 82
  test "should use dictionary's external address when linking" do
    reku = dictionaries(:one).lexemes.first
    get :show, :id => reku.id
    assert_present reku.dictionaries
    assert_present reku.headwords
    assert_select "a[href=?]", /#{Regexp.escape(dictionaries(:one).external_address)}.*/
  end
  
  #139: Make sure the button images behind the submit buttons exist
  test "button images should exist" do
    assert Rails.application.assets.find_asset('button_yellow.png'), "Yellow button is missing"
    assert Rails.application.assets.find_asset('button_gray.png'), "Gray button is missing"
  end
  
  # 161b: Nested attributes are not working to create parses
  test "should be able to create new parses by nested attributes" do
	  assert_difference('Parse.count') do
      put :update, id: lexemes(:one).id, 
        lexeme:
          { subentries_attributes: { 0 =>
            { etymotheses_attributes: { 0 =>
              { etymology_attributes:
                { etymon: "tested",
                  parses_attributes: { 0 =>
                  { parsed_form_en: "test",
                    interpretations_attributes: { 0 =>
                      { sense_id: "1",
                        sense_attributes: { definition_en: "" }}}}}}}}}}}
    end
  end
  
  # 177: The add subentry link wasn't correctly making a sense under 
  # the subentry
  test "should be able to create new subentries from the lexeme form" do
    Capybara.current_driver = :webkit
    
    visit new_lexeme_path
    click_link I18n.t('lexemes.form.add_subentry')
   
    page.all('input[type="text"],textarea').each do |elem|
      elem.set "test"
    end

    click_button I18n.t('lexemes.new.create')
    
    assert page.has_content?(I18n.t('lexemes.create.successful_create'))
  end
end
