require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class HeadwordTest < ActiveSupport::TestCase
  test "API" do
    hw = Headword.new
    
    api = [:acceptance, :descriptively_ok?, :prescriptively_ok?, :notes]
    api.each {|method| assert hw.respond_to?(method), "Doesn't respond to ##{method}"}
  end
  
  # 179: Errors when adding a lexeme to multiple dictionaries
  # Needed to define a way to do this. Just return the first if
  # nothing is specified
  test "#form should not return nil if another form is present" do
    assert_not_nil headwords(:"179_multilocale").form
  end
  
  # 179: Errors when adding a lexeme to multiple dictionaries
  # Needed to define a way to do this.  This MAY return nil if
  # there's no appropriate form.
  test "#form should be able to take a language as an argument" do
    assert_equal "teneo", headwords(:"179_multilocale").form(:la)
  end
end
