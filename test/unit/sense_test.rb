require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class SenseTest < ActiveSupport::TestCase
  # 137: Accepts_nested_attributes_for was not correctly testing the blankness of glosses
  test "associated Glosses should be rejectable if their gloss is empty" do
    assert_no_difference 'Gloss.count' do
      Sense.find_each do |sen|
        guro = sen.glosses.build(gloss: "")
        assert guro.invalid?, "#{sen.id}: attributes #{guro.attributes}"
      end
    end
  end
  
  # 205: lookup_all_by_headword was not working with translations
  test "lookup all by headword should return appropriate results" do
    lex = Lexeme.create
    I18n.with_locale(:es) do
      lex.headwords.create(form: "205_prueba")
    end
    subentry = lex.subentries.create
    sense = subentry.senses.create(definition_en: "Testing.")
    
    result = Sense.lookup_all_by_headword("205_prueba")
    assert result.include?(sense), "#{result} doesn't include #{sense.inspect}"
  end
end
