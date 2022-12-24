require "test_helper"

class SharecoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get shareco_index_url
    assert_response :success
  end
end
