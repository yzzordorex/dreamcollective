require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get login_path
    assert_response :success
  end

  test "should get signup" do
    get signup_path
    assert_response :success
  end

  test "should get verify_email" do
    bill = users(:bill)
    get verify_url token: bill.token
    assert_redirected_to profile_path
  end
end
