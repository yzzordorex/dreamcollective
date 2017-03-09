class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def create
    @user = User.new(allowed_params
                      .merge({last_login: DateTime.current,
                              ip_address: request.remote_ip}))
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: 'Thanks for signing up!'
    else
      render :new
    end
  end

  private
  def allowed_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
