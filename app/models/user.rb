class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true
  has_many :dreams

  def update_session_attrs(remote_ip)
    begin
      update(last_login: DateTime.current, ip_address: remote_ip)
      self.save
    rescue
      # log something
    end
  end



  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
