require "test_helper"

class SharingcarControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sharingcar_index_url
    assert_response :success
  end
end
