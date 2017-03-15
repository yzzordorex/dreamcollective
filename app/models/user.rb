class User < ApplicationRecord
  has_secure_password

  before_create :set_email_verification_token
  before_save { self.email = email.downcase }
  before_save :unverify, if: :email_changed?
  
  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: /\A\S+@\S+\.\S+\z/ }
  
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
  def unverify
    self.token = email_verification_token
    self.verified = false
    self.token_expires_at = 10.days.from_now
  end
  
  def set_email_verification_token
    self.token = email_verification_token
  end
  
  def email_verification_token
    SecureRandom.urlsafe_base64.to_s
  end
  
end
