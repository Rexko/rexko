require File.dirname(__FILE__) + '/../test_helper'

class LanguageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "to_s" do
    assert_equal "Testwegian (zxx)", "#{languages(:testwegian)}"
    assert_equal "Testian", "#{languages(:without_code)}"
    assert_equal "Testian", "#{languages(:with_blank_code)}"
  end
end
