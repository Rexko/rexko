require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class HeadwordTest < ActiveSupport::TestCase
  test "API" do
    hw = Headword.new
    
    api = [:acceptance, :descriptively_ok?, :prescriptively_ok?, :notes]
    api.each {|method| assert hw.respond_to?(method), "Doesn't respond to ##{method}"}
  end
end
