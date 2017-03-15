require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(email: 'clams@casino.biz', password: 'super secret', password_confirmation: 'super secret')
  end
  test "should get new" do
    get login_url
    assert_response :success
  end

  test "" do
    
  end
end
