require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get login page" do
    get login_path
    assert_response :success
  end

  test "should get signup page" do
    get signup_path
    assert_response :success
  end
  
  test "non logged-in users should not get settings edit page" do
    get edit_settings_path
    assert_redirected_to login_path
  end
  
  test "logged-in users should get settings edit page" do
    sign_in_as users(:ted).email, "password"
    get edit_settings_path
    assert_response :success
  end
  
  test "should get verify page" do
    bill = users(:bill)
    get verify_url token: bill.token
    assert_redirected_to settings_path
  end

  test "should require email verification after creation" do
    captain = {email: "captain@logan.net", password: "supersecret", password_confirmation: "supersecret"}
    post users_path(user: captain)
    assert_redirected_to root_path
    get settings_path
    assert_redirected_to login_path
  end

  test "welcome email enqueued to be delivered later" do
    logan = {email: "logan@captain.net", password: "supersecret", password_confirmation: "supersecret"}
    assert_enqueued_jobs 1 do
      post users_path(user: logan)
    end
  end

  test "welcome emails are delivered with expected content" do
    captain = {email: "captain@logan.net", password: "supersecret", password_confirmation: "supersecret"}
    perform_enqueued_jobs do
      post users_path(user: captain)
      delivered_email = ActionMailer::Base.deliveries.last
      assert_includes delivered_email.to, captain[:email]
    end
  end

  test "verification email enqueued to be delivered later" do
    ted = users(:ted)
    sign_in_as ted.email, "password"
    assert_enqueued_jobs 1 do
      patch user_path(ted.id), params: {user: {email: "some_other_email@adventure.gov"}}
    end
  end

  test "verification emails are delivered with expected content" do
    ted = users(:ted)
    new_email = "some_other_email@adventure.gov"
    sign_in_as ted.email, "password"
    perform_enqueued_jobs do
      patch user_path(ted.id), params: {user: {email: new_email}}
      delivered_email = ActionMailer::Base.deliveries.last
      assert_includes delivered_email.to, new_email
    end
  end
end
