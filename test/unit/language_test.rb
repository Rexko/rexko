# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class LanguageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "to_s" do
    assert_equal "Testwegian (zxx)", "#{languages(:testwegian)}"
    assert_equal "Testian", "#{languages(:without_code)}"
    assert_equal "Testian", "#{languages(:with_blank_code)}"
  end
  
  test "name" do
    assert_equal "Testwegian", languages(:testwegian).name
    assert_equal "zxx", languages(:without_default_name).name
    assert_equal Language::UNKNOWN_LANGUAGE % languages(:without_default_name_or_code).id, languages(:without_default_name_or_code).name
  end
  
  # Sorting for #125
  test "should be able to sort based on default sort order" do
    mul = Language::MULTIPLE_LANGUAGES
    hw1, hw2, hw3 = Headword.new(form: "A"), Headword.new(form: "B"), Headword.new(form: "C")
    
    assert mul.respond_to?(:sort), "should have a #sort method"
    assert_equal [hw1, hw2, hw3], mul.sort([hw3, hw1, hw2], by: :form), "should sort CAB > ABC in default case"
  end
  
  test "should be able to sort data that may have multiple languages" do
    hw1, hw2, hw3 = Headword.new(form: "A"), Headword.new(form: "B"), Headword.new(form: "C")
    hw1.language = languages(:latin)
    hw2.language = languages(:spanish)
    # hw3 unspecified
    
    assert Language.respond_to?(:sort_using_lang_for), "should have a #sort_using_lang_for method"
    assert_equal [hw1, hw2, hw3], Language.sort_using_lang_for([hw3, hw1, hw2], by: :form), "should sort CAB > ABC in default case"
  end
  
  test "should be able to sort based on custom sort order using substitutions" do
    la, tw = languages(:latin), languages(:testwegian)
    hw1, hw2, hw3 = Headword.new(form: "Iapetus"), Headword.new(form: "jaspis"), Headword.new(form: "ibex")
    
    # Using substitutions defined for the language
    # In Latin, J sorts as I; and nowhere really should case be primary
    assert_equal [hw1, hw2, hw3], la.sort([hw3, hw1, hw2], by: :form), "Latin order should be Iapetus, jaspis, ibex"
    
    # Specifying substitutions explicitly
    assert_equal [hw1, hw2, hw3], tw.sort([hw3, hw1, hw2], by: :form, sub: {"J" => "I"}), "Custom order should be Iapetus, jaspis, ibex"
  end

  test "should be able to sort based on custom sort order using reorderings" do
    es, tw = languages(:spanish), languages(:testwegian)
    hw1, hw2, hw3 = Headword.new(form: "ananás"), Headword.new(form: "ñame"), Headword.new(form: "plátano")

    # Using reorderings defined for the language
    # In Spanish, Ñ sorts just after N
    assert_equal [hw1, hw2, hw3], es.sort([hw3, hw1, hw2], by: :form), "Spanish order should be ananás, ñame, plátano"

    # Specifying substitutions explicitly
    assert_equal [hw1, hw2, hw3], tw.sort([hw3, hw1, hw2], by: :form, order: { "Ñ" => "N" }), "Custom order should be ananás, ñame, plátano"
  end
end
