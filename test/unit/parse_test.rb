require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ParseTest < ActiveSupport::TestCase
	def test_forms_of
		paasu = [parses(:one), parses(:two)]
		result = Parse.forms_of(paasu)
		assert_not_nil result
		assert_equal 2, result.length
		assert result.include?("foo"), "should include 'foo'"
		assert result.include?("bar"), "should include 'bar'"
		
		assert_equal result, paasu.collect(&:parsed_form)
	end
end
