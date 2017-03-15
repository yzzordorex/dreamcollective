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

  test "should require email verification after creation" do
    captain = {email: "captain@logan.net", password: "supersecret", password_confirmation: "supersecret"}
    post users_path(user: captain) #email: "hail@ceasar.biz", password: "supersecret", password_confirmation: "supersecret")
    assert_redirected_to root_path
    get profile_path
    assert_redirected_to root_path
  end
end
