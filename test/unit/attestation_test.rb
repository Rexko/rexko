require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class AttestationTest < ActiveSupport::TestCase
  def test_attested_form_present
    # Attestation must have an attested_form
    assert attestations(:valid_attestation).valid?
    assert !attestations(:invalid_attestation).valid?
  end
  
  def test_parse_assignment
    @parsendum = attestations(:valid_attestation)
    @one = parses(:one)
    @two = parses(:two)
    assert_equal 2, @parsendum.parses.size
    
    @parsendum.parses_attributes = [{ :id => @one.id, :parsed_form => "baz"}]
    @parsendum.save
    assert_equal "baz", Parse.find(@one.id).parsed_form
    assert_not_equal "foo", Parse.find(@one.id).parsed_form
    
    @parsendum.parses_attributes = [{ :id => @two.id, :parsed_form => ""}]
    
    assert !@parsendum.save || Parse.find(@two.id).parsed_form != "", "Attributes are #{Parse.find(@two.id).attributes}"
  end
end
