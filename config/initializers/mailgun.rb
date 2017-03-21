mailgun_config = Rails.application.config_for(:mailgun)


Mailgun.configure do |config|
  config.api_key = mailgun_config["api_key"]
end
