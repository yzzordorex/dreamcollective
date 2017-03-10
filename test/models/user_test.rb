require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user = User.new(email: 'clams@casino.biz', password: 'super secret', password_confirmation: 'super secret')
    assert user.valid?
  end
  test "invalid without email" do
    user = User.new(password: 'super secret', password_confirmation: 'super secret')
    refute user.valid?, 'user is valid without an email'
    assert_not_nil user.errors[:email], 'no validation error for email'
  end

  test "has secure password" do
    user = User.new(email: 'clams@casino.biz', password: 'super secret', password_confirmation: 'super secret')
    assert_respond_to user, :password_digest
    assert_respond_to user, :authenticate, "User requires has_secure_password"
  end

  
end
