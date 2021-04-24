require "test_helper"

class OrdersDetailsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get orders_details_index_url
    assert_response :success
  end
end
