require 'test_helper'

class CheckoutControllerTest < ActionDispatch::IntegrationTest
  test "should get addToCart" do
    get checkout_addToCart_url
    assert_response :success
  end

  test "should get discountedTotal" do
    get checkout_discountedTotal_url
    assert_response :success
  end

end
