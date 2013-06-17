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
	
	def test_unattached_to
		paasu = Parse.forms_of(Parse.find(:all)).uniq
		paasu.each do |f|
  		result = Parse.unattached_to f
  		assert_equal Parse.count_unattached_to(f), result.length 
  	end
	end
	
	test "should reject blank interpretations and only blank interpretations" do
	  valid_params = { :parsed_form => "valid", :interpretations_attributes => [{ :sense_id => senses(:one).id }] }
    invalid_params = { :parsed_form => "valid", :interpretations_attributes => [{ :sense_id => "" }] }
	  
	  assert_difference('Interpretation.count') do
      Parse.create(valid_params)
	  end
	  
	  assert_no_difference('Interpretation.count') do
	    Parse.create(invalid_params)
	  end
  end
end
