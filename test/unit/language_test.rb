require File.dirname(__FILE__) + '/../test_helper'

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
    assert_equal "Unknown language 21", languages(:without_default_name_or_code).name
  end
end
