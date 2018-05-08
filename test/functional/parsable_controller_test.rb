require 'test_helper'

class ParsableControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end
  
  # 176: Loci#unattached is failing when the unattached is an etymology
  test "should get unattached when it's an etymology" do
    get :index, params: { forms: ["unattached"] }

    assert_response :success
  end
end
