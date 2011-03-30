require File.dirname(__FILE__) + '/../test_helper'

class LanguageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "to_s" do
    assert_equal "Testwegian (zxx)", "#{languages(:testwegian)}"
  end
end
