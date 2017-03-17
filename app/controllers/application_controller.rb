class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  def logged_in?
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :logged_in?

  def require_login
    redirect_to login_url unless logged_in?
  end
  
  def authorize
    redirect_to '/login' unless logged_in?
  end
end
