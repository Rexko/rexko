require 'test_helper'

class LexemesHelperTest < ActionView::TestCase
  include ApplicationHelper
  
  test "titleize_headwords_for" do
    assert_equal "Liter or litre", titleize_headwords_for(lexemes(:liter_lex))
  end
end
