require 'test_helper'

class DreamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dream = dreams(:one)
  end

  test "should get index" do
    get dreams_url
    assert_response :success
  end

  test "should redirect if getting new while logged out" do
    get new_dream_url
    assert_response :redirect
  end

  test "should get new while logged in" do
    sign_in_as(User.first.email, 'password')
    get new_dream_url
    assert_response :success
  end

  test "should redirect if posting dream while logged out" do
  #TODO should we save the posted dream in the session so the user doesn't have to retype the whole thing?
    post dreams_url
    assert_response :redirect
  end

  test "should create dream while logged in" do
    sign_in_as(users(:plato).email, 'password')
    assert_difference('Dream.count') do
      post dreams_url, params: { dream: { body: @dream.body, date_occurred: @dream.date_occurred, title: @dream.title, all_tags: @dream.all_tags } }
    end

    assert_redirected_to dream_url(Dream.last)
  end

  test "should show dream" do
    get dream_url(@dream)
    assert_response :success
  end

  test "should get edit for current user's dream if logged in" do
    sign_in_as(users(:plato).email, 'password')
    @dream = users(:plato).dreams.first
    get edit_dream_url(@dream)
    assert_response :success
  end

  test "should not get edit of someone else's dream when logged in" do
    sign_in_as(users(:ted).email, 'password')
    @dream = users(:plato).dreams.first
    get edit_dream_url(@dream)
    assert_response :redirect
  end
    

  test "should not get edit and should redirect to login if not logged in" do
    get edit_dream_url(@dream)
    assert_redirected_to login_path
  end

  test "should update dream if logged in" do
    sign_in_as(users(:plato).email, 'password')
    patch dream_url(@dream), params: { dream: { body: @dream.body, date_occurred: @dream.date_occurred, title: @dream.title, all_tags: @dream.all_tags } }
    assert_redirected_to dream_url(@dream)
  end

  test "should not update dream and should redirect to login if not logged in" do
    patch dream_url(@dream), params: { dream: { body: @dream.body, date_occurred: @dream.date_occurred, title: @dream.title, all_tags: @dream.all_tags } }
    assert_redirected_to login_path
  end

=begin -- TODO acts_as_paranoid
  test "should destroy dream" do
    assert_difference('Dream.count', -1) do
      delete dream_url(@dream)
    end
    assert_redirected_to dreams_url
  end
=end
end
