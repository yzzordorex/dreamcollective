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

  test "should create dream" do
    assert_difference('Dream.count') do
      @current_user = Session.new(User.first)
      post dreams_url, params: { dream: { user: @current_user, body: @dream.body, date_occurred: @dream.date_occurred, title: @dream.title, all_tags: @dream.all_tags } }
    end

    assert_redirected_to dream_url(Dream.last)
  end

  test "should show dream" do
    get dream_url(@dream)
    assert_response :success
  end

  test "should get edit if logged in" do
    get edit_dream_url(@dream)
    assert_response :success
  end

  test "should update dream" do
    patch dream_url(@dream), params: { dream: { user_id: @dream.user_id, body: @dream.body, date_occurred: @dream.date_occurred, title: @dream.title, all_tags: @dream.all_tags } }
    assert_redirected_to dream_url(@dream)
  end

  test "should destroy dream" do
    assert_difference('Dream.count', -1) do
      delete dream_url(@dream)
    end

    assert_redirected_to dreams_url
  end
end
