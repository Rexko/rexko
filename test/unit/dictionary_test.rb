require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class DictionaryTest < ActiveSupport::TestCase
  # 82: A dictionary should know where it is.
  test "should know where its external store is" do
    diku = Dictionary.new
    
    assert diku.respond_to?(:external_address)
  end
end
