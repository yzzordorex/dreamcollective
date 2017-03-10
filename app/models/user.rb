class User < ApplicationRecord
  has_secure_password
  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: /\A\S+@\S+\.\S+\z/ }
  before_create :email_confirmation_token

  def verify!
    update(verified: true, token: nil, token_expires_at: nil)
    self.save
  end
  
  def update_session_attrs(remote_ip)
    begin
      update(last_login: DateTime.current, ip_address: remote_ip)
      self.save
    rescue
      # log something
    end
  end
  
  def welcome
    SendNewUserWelcomeJob.perform_later(id)
  end

  def confirm_email
    SendUserEmailConfirmationJob.perform_later(id)
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  private
  def email_confirmation_token
    if self.token.blank?
      self.token = SecureRandom.urlsafe_base64.to_s
    end
  end
end
