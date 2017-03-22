class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:email])
    if user and user.authenticate(params[:password]) and user.verified
      session[:user_id] = user.id
      user.update_session_attrs(request.remote_ip)
      redirect_to root_url, notice: 'Logged in!'
    else
      flash.now.alert = 'Login failed!'
      redirect_to login_path
    end
  end
  def destroy
    session.delete(:user_id)
    redirect_to root_url, notice: 'Logged out!'
  end
end
