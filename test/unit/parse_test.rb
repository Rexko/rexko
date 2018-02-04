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
		paasu = Parse.forms_of(Parse.all).uniq
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
  
  # 71: Case variants erroneously flagged as not existing
  test "most wanted should be initial-case-insensitive" do
    assert Headword.where(form: "blue").present?
    assert Headword.where(form: "Blue").blank?
    
    100.times { Parse.create(parsed_form: "Blue") }
    most_wanted = Parse.most_wanted 1
    
    assert_not_equal "Blue", most_wanted.first.try(:parsed_form)
  end

  # 119: Locus#most_wanted_parse is doing a lot of work that Parse
  # should be doing. Moved it to Parse#most_wanted_in
  test "most_wanted_in(locus, count) should be a functioning scope" do
    assert Parse.respond_to?(:most_wanted_in)

    Locus.find_each do |roka|
      mwi_parse = Parse.most_wanted_in(roka).first
      roka_parse = roka.parses.without_entries.inject([]) { |memo, paasu| 
        memo.count > paasu.count ? memo : paasu
      }

      if roka_parse.present? && mwi_parse.present?
        assert_equal roka_parse.count, mwi_parse.count, "Locus #{roka.id} does not match - Locus gives #{roka_parse}, MWI gives #{mwi_parse}"
      else # if one is empty, there are no wanted parses, and both should be empty
        assert_equal mwi_parse.blank?, roka_parse.blank?
      end
    end
  end
  
  # 143: Some unattached parses were being found by most_wanted but not 
  # count_unattached_to.  We determined that we were only searching for
  # interpretations unattached to parses, not those unattached to senses
  test "#count_unattached_to's results should find those not attached to senses, too" do
    TEST_STRING = "#143parse"
    
    parse = Parse.create(parsed_form: TEST_STRING)
    terp = parse.interpretations.create

    assert terp.sense.nil? 
    assert_equal 1, Parse.count_unattached_to(TEST_STRING)
  end
end
