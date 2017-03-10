class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true

  def update_session_attrs(remote_ip)
    begin
      update(last_login: DateTime.current, ip_address: remote_ip)
      self.save
    rescue
      # log something
    end

  def welcome
    SendNewUserWelcomeJob.perform_later(id)
  end

  def confirm_email
    SendUserEmailConfirmationJob.perform_later(id)
  end
end
