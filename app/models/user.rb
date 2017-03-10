class User < ApplicationRecord
  has_secure_password

  def welcome
    SendNewUserWelcomeJob.perform_later(id)
  end

  def confirm_email
    SendUserEmailConfirmationJob.perform_later(id)
  end
end
