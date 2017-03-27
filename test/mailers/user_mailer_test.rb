require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'welcome' do
    bill = users(:bill)
    email = UserMailer.welcome(bill)
    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ['morpheus@dreamcollective.net'], email.from
    assert_equal [bill.email], email.to
    assert_equal 'Welcome to DreamCollective', email.subject
  end

  test 'verify' do
    bill = users(:bill)
    email = UserMailer.verify(bill)
    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ['morpheus@dreamcollective.net'], email.from
    assert_equal [bill.email], email.to
    assert_equal 'Account Email Address Updated', email.subject
  end
  
end
