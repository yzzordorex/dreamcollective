require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user = User.new(email: 'clams@casino.biz', password: 'super secret', password_confirmation: 'super secret')
    assert user.valid?

    refute user.verified
    refute user.admin
  end
  test "invalid without email" do
    user = User.new(password: 'super secret', password_confirmation: 'super secret')
    refute user.valid?, 'user is valid without an email'
    assert_not_nil user.errors[:email], 'no validation error for email'
  end

  test "uniqueness of emails" do
    base_params = {password: 'super secret', password_confirmation: 'super secret'}
    dupe = 'thing@dinger.com'
    original_user = User.new(base_params.merge(email: dupe))
    assert original_user.valid?
    original_user.save
    
    dupe_user = User.new(base_params.merge(email: dupe))
    refute dupe_user.valid?, 'user is valid with duplicate email'
    assert_not_nil dupe_user.errors[:email], 'no validation errors for email'
  end

  test "email validations" do
    base_params = {password: 'super secret', password_confirmation: 'super secret'}
    good_emails = ['foo@bar.com', 'f.o.o@bar.com', 'foo@r.whocares']
    bad_emails = ['foo@bar', 'foo.com', 'foo', 'foo@', 'foo@bar']
    good_emails.each do |good_email|
      user = User.new(base_params.merge(email: good_email))
      assert user.valid?
    end
    bad_emails.each do |bad_email|
      user = User.new(base_params.merge(email: bad_email))
      refute user.valid?, 'user is valid with invalid email ' + bad_email
      assert_not_nil user.errors[:email], 'no validation error for email'
    end
  end
  
  test "has secure password" do
    user = User.new(email: 'clams@casino.biz', password: 'super secret', password_confirmation: 'super secret')
    assert_respond_to user, :password_digest
    assert_respond_to user, :authenticate, "User requires has_secure_password"
  end

  test "when email address is updated" do
    ted = users(:ted)
    email_address, confirmation_token = ted.email, ted.token
    assert ted.verified
    new_email_address = 'theo@tardis.org'
    assert email_address != new_email_address
    ted.email = new_email_address
    ted.save
    #refute ted.verified
    
  end
  
end
