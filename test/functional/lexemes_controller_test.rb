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
      post :create, params: { :lexeme => { } }
    end

    assert_redirected_to lexeme_path(assigns(:lexeme))
  end

  def test_should_show_lexeme
    get :show, params: { :id => lexemes(:one).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, params: { :id => lexemes(:one).id }
    assert_response :success
  end

  def test_should_update_lexeme
    put :update, params: { :id => lexemes(:one).id }
    assert_redirected_to lexeme_path(assigns(:lexeme))
  end

  def test_should_destroy_lexeme
    assert_difference('Lexeme.count', -1) do
      delete :destroy, params: { :id => lexemes(:one).id }
    end

    assert_redirected_to lexemes_path
  end
  
  def test_fixture_should_set_up_correctly
    assert lexemes(:liter_lex).headwords.count > 0, "Test fixture should have more than zero headwords"
    assert loci(:nemo).attests?("litre"), "Fixture loci(:nemo) should attest 'litre'."
    assert Locus.attesting(lexemes(:liter_lex)).count.count > 0, "Loci should attest the 'liter' lexeme."

    assert lexemes(:liter_lex).loci.count.count > 0, "Test fixture does not have any loci for further tests"    
  end
  
  # 'show' should create a @loci_for hash that breaks out constructions by 
  # headword form.
  def test_show_should_assign_loci_for
    get :show, params: { :id => lexemes(:liter_lex).id }
    
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
    get :show_by_headword, params: { :headword => "liter", :matchtype => Lexeme::EXACT }
    
    lexeme = assigns(:lexeme)
    assert_not_nil lexeme, "Headword 'liter' should return a lexeme; 'liter's lexeme is #{Lexeme.lookup_by_headword('liter')}"
    assert_equal 1, lexeme.length, "Headword 'liter' should return only one lexeme"
    
    get :show_by_headword, params: { :headword => "spring", :matchtype => Lexeme::EXACT }
    
    lexeme = assigns(:lexeme)
    assert_not_nil lexeme, "Headword 'spring' should return a lexeme"
    assert lexeme.length > 1, "Headword 'spring' should return more than one lexeme"
  end
  
  def test_matching_uses_template
    get :matching, params: { :headword => "spring", :matchtype => Lexeme::SUBSTRING }
    
    assert_template "layouts/1col_layout"
  end
  
  def test_matching_sets_title
    get :matching, params: { :headword => "spring", :matchtype => Lexeme::SUBSTRING }
    
    title = assigns(:page_title)
    assert_not_nil title, "Show_by_headword should set a title"
    assert_equal "Lexemes - 2 results for \"spring\"", title
  end
  
  def test_show_by_headword_respects_match_type
    get :show_by_headword, params: { :headword => "liter", :matchtype => Lexeme::SUBSTRING }
    
    results = assigns(:lexeme)
    assert results.length > 1, 
      "Substring search for 'liter' found #{results.length}; there are at least two in the fixtures"
    
    get :show_by_headword, params: { :headword => "liter", :matchtype => Lexeme::EXACT }
    
    results = assigns(:lexeme)
    assert_equal 1, results.length,
      "Exact search for 'liter' found #{results.length}; there should only be one in the fixtures"
  end
  
  def test_substring_search_friendly_url
    assert_recognizes({:controller => "lexemes", :action => "matching", :headword => 'liter', :matchtype => Lexeme::SUBSTRING }, "/lexemes/matching/liter")
    
    get :show_by_headword, params: { :headword => "liter", :matchtype => Lexeme::SUBSTRING }
    
    assert_redirected_to "/en/lexemes/matching/contains/liter"
  end
  
  test "don't fail if locus contains a construction that does not reference it" do
    blue = lexemes(:appearing_in_construction_a)
    blue_jay = lexemes(:with_construction)
    assert Lexeme.attested_by(loci(:with_constructions).attestations, "Attestation").include? blue_jay
    assert Lexeme.attested_by(loci(:with_constructions).attestations, "Attestation").include? blue
    assert Lexeme.attested_by(loci(:with_same_construction).attestations, "Attestation").include? blue_jay
    assert !Lexeme.attested_by(loci(:with_same_construction).attestations, "Attestation").include?(blue)  
      
    get :show, params: { :id => lexemes(:appearing_in_construction_a).id }
    assert_response :success
  end
    
  # 82
  test "should use dictionary's external address when linking" do
    reku = dictionaries(:one).lexemes.first
    get :show, params: { :id => reku.id }
    assert reku.dictionaries.present?
    assert reku.headwords.present?

    assert_select "a[href^=?]", dictionaries(:one).external_address
  end
  
  #139: Make sure the button images behind the submit buttons exist
  test "button images should exist" do
    assert Rails.application.assets.find_asset('button_yellow.png'), "Yellow button is missing"
    assert Rails.application.assets.find_asset('button_gray.png'), "Gray button is missing"
  end
  
  # 161b: Nested attributes are not working to create parses
  test "should be able to create new parses by nested attributes" do
	  assert_difference('Parse.count') do
      put :update, params: { id: lexemes(:one).id, lexeme:
          { subentries_attributes: { "0" =>
            { etymotheses_attributes: { "0" =>
              { etymology_attributes:
                { etymon: "tested",
                  parses_attributes: { "0" =>
                  { parsed_form_en: "test",
                    interpretations_attributes: { "0" =>
                      { sense_id: "1",
                        sense_attributes: { definition_en: "" }}}}}}}}}}} }
    end
  end
  
  # 177: The add subentry link wasn't correctly making a sense under 
  # the subentry
  test "should be able to create new subentries from the lexeme form" do
    Capybara.current_driver = :webkit
    
    visit new_lexeme_path

    field_count = page.all('input[type="text"],textarea').count
    click_link I18n.t('lexemes.form.add_subentry')
   
    page.all('input[type="text"],textarea', minimum: field_count + 1).each do |elem|
      elem.set "test"
    end

    click_button I18n.t('lexemes.new.create')
    
    assert page.has_content?(I18n.t('lexemes.create.successful_create'))
  end
  
  # 179: Errors when adding a lexeme to multiple dictionaries
  # Behavior on show when a lexeme is in multiple language dictionaries
  # was not defined.  It was showing nothing; eventually should find
  # a way to show each
  test "should display correctly if lexeme is in multiple language dictionaries" do
    get :show, params: { id: lexemes(:"179_in_multiple_language_dictionaries").id }
    
    assert_select ".lexform-paradigm", /tene/
  end
  
  # 93: 
  # The lexeme edit form should include an autocomplete for the source language.
  # (It was formerly listing the languages in creation order.)
  test "should display language autocomplete" do
    get :edit, params: { id: lexemes(:literal).id }
    
    assert_select 'span[id$=search-indicator]'
  end
  
  # 159: [Failure to delete etymology sources in the lexeme edit form properly]
  # Found a failure to *show* them at all, but couldn't repro reported issue
  # Also it should dissociate, not delete.
  test "should handle etymology sources in edit form correctly" do
    lexeme = lexemes(:"159_with_etymology_source")
    subentry = lexeme.subentries.first
    subentry_count = lexeme.subentries.count
    etymothesis = subentry.etymotheses.first
    etymo_count = subentry.etymotheses.count
    source = etymothesis.source

    get :edit, params: { id: lexeme.id }
    
    # Make sure the source section is shown
    # Also check number of subentries as error in update hash caused duplication
    assert_select '.subentry', subentry_count
    assert_select '.etymothesis .source', etymo_count
    
    # Make sure that it doesn't actually delete the source
	  assert_no_difference('Source.count') do
      put :update, params: { id: lexeme.id, commit: I18n.t('lexemes.form.save_and_continue_editing'), lexeme: lexeme.attributes.except("id", "created_at", "updated_at") }
      assert_select '.subentry', subentry_count
      assert_select '.etymothesis .source', etymo_count

      put :update, params: { id: lexeme.id, commit: I18n.t('lexemes.form.save_and_continue_editing'), lexeme:
          { subentries_attributes: 
            { "0" => 
              { id: subentry.id,
                etymotheses_attributes: 
                { "0" => 
                  { id: etymothesis.id,
                    source_attributes:
                    { id: source.id,
                      authorship_attributes:
                      { id: source.authorship_id
                      },
                      pointer: source.pointer,
                      _destroy: 1 
                    }
                  }
                }
              }
            }
          } }

      # Make sure it's no longer associated with the lexeme
      assert_select '.subentry', subentry_count
      assert_select '.etymothesis .source', etymo_count.pred
    end
  end
  
  # 192: Issue where more than one note couldn't be added.
  test "should be able to add more than one note to an item" do
       Capybara.current_driver = :webkit
    
       visit new_lexeme_path
       note_count = page.all('.note').count

       first('.headword').click_link(I18n.t('helpers.link_to_add.note'))
       assert_selector('.note', count: note_count + 1)
       
       first('.headword').click_link(I18n.t('helpers.link_to_add.note'))
       assert_selector('.note', count: note_count + 2)
          
       page.all('input[type="text"],textarea').each_with_index do |elem, i|
         elem.set "test #{i}"
       end

       click_button I18n.t('lexemes.form.save_and_continue_editing')
    
       assert_text I18n.t('lexemes.create.successful_create')
       assert_selector('.note', count: note_count + 2)
  end
  
  # 188: Show all languages for which there is data on edit form
  test "Lexeme edit should show all languages with data" do
    # control
    get :edit, params: { id: lexemes(:"179_in_multiple_language_dictionaries").id }
    assert_select '.headword .language-list li', /la/
    
    # change a headword locale
    languages(:latin).iso_639_code = "xxx"
    languages(:latin).save
    
    # should still show the 'la' headword, as well as the 'xxx' prompt
    get :edit, params: { id: lexemes(:"179_in_multiple_language_dictionaries").id }
    assert_select '.headword .language-list li', /la/
    assert_select '.headword .language-list li', /xxx/
  end
  
  # 187. Pronunciations and parts of speech not displaying in lexemes/matching.
  test "lexemes/matching should show pronunciation and parts of speech" do
    lex = Lexeme.create
    lex.dictionaries << dictionaries(:es_dict)
    I18n.with_locale(:es) do
      hw = lex.headwords.create form: "187_test"
      hw.phonetic_forms.create form: "187_tEst"
    end
    
    get :matching, params: { headword: "187_test" }
    
    assert_select ".lexform-phonetic-form", /187_tEst/
  end
  
  # 239. Glosses not displaying in lexeme/show wiki format
  test "wiki format should display glosses in lexeme/show" do
    lex = Lexeme.create
    lex.dictionaries << dictionaries(:one)
    dictionaries(:one).target_language = languages(:spanish)
    dictionaries(:one).save!
    
    lex.headwords.create form: "Test"
    
    subentry = lex.subentries.create
    sense = subentry.senses.create definition: "Test def."
    sense.glosses.create gloss_es: "sought"
    
    get :show, params: { id: lex.id }
    
    assert_select ".wikified-headword textarea", /#\* sought/
    assert_select ".wikified-lexeme textarea", /#\* sought/
  end
  
  # 253. Headwords in URLs should be able to contain special characters
  test "special characters should be possible in headwords in URLs" do
    examples = ['word', '.ubu.', 'either/or']
    
    examples.each do |word|
      assert_recognizes({ controller: 'lexemes', action: 'matching',
                          headword: word, matchtype: Lexeme::SUBSTRING },
                          "lexemes/matching/contains/#{word}")
    end
  end
end
