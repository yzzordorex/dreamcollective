require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(email: 'clams@casino.biz', password: 'super secret', password_confirmation: 'super secret')
  end
  test "should get new" do
    get login_url
    assert_response :success
  end

  test "login for unverified user" do
    sign_in_as users(:bill).email, "password"
    assert_redirected_to login_path
  end
  
  test "login for verified user" do
    sign_in_as users(:ted).email, "password"
    assert_redirected_to root_path
  end
end
