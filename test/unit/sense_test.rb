require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class SenseTest < ActiveSupport::TestCase
  # 137: Accepts_nested_attributes_for was not correctly testing the blankness of glosses
  test "associated Glosses should be rejectable if their gloss is empty" do
    assert_no_difference 'Gloss.count' do
      Sense.find_each do |sen|
        guro = sen.glosses.build(gloss: "")
        assert Gloss.rejectable?(guro), "#{sen.id}: attributes #{guro.attributes}"
      end
    end
  end
end
