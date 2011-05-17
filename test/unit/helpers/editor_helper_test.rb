require 'test_helper'

class EditorHelperTest < ActionView::TestCase
  include ApplicationHelper
  
  test "ten_most_wanted should be html_safe" do
    assert ten_most_wanted.html_safe?
  end
  
  test "expandlist should be html_safe" do
    assert expandlist.html_safe?
  end
end
