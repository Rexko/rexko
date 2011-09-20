require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class LocusTest < ActiveSupport::TestCase
  fixtures :loci, :attestations, :parses
  
  def test_attests_form
    assert loci(:natvilcius).attests?("liters"), "#attests? should report :natvilcius containing 'liters'"
    assert loci(:nemo).attests?("litres"), "#attests? should report :nemo containing 'litres'"
    
    assert !loci(:natvilcius).attests?("litres"), "#attests? should not report :natvilcius containing 'litres'"
    assert !loci(:nemo).attests?("liters"), "#attests? should not report :nemo containing 'liters'"
  end
  
  test "unattached" do
    assert Locus.unattached(lexemes(:liter_lex)).blank?
    
    Interpretation.delete_all
    
    assert Locus.unattached(lexemes(:liter_lex)).present?
  end
  
  test "attesting should not return dups" do
  	loci = Locus.attesting(lexemes(:literal)).all
  	
  	assert_equal loci.uniq, loci
  end
end
