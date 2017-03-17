class SendUserEmailVerificationJob < ApplicationJob
  queue_as :user_email_verifications

  def perform(user_id)
    user = User.find(user_id)
    UserMailer.verify(user).deliver_now
  end
end
