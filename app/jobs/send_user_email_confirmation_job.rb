class SendUserEmailConfirmationJob < ApplicationJob
  queue_as :user_email_confirmations

  def perform(user_id)
    user = User.find(user_id)
    UserMailer.verify_email(user).deliver_now
  end
end
