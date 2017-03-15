class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(allowed_params
                      .merge({last_login: DateTime.current,
                              ip_address: request.remote_ip}))
    if @user.save
      @user.welcome
      #session[:user_id] = @user.id
      redirect_to root_url, notice: 'Thanks for signing up! Please check your email to complete the registration process.'
    else
      render :new
    end
  end

  def verify
    @user = User.where("token = :token AND token_expires_at > :now AND verified = false",
                       {token: params[:token], now: Time.now}).take!
    if @user and @user.verify!
      # update user, set session, and redirect to /show
      session[:user_id] = @user.id
      redirect_to profile_url, notice: 'Thanks for verifying your email address. Your account is now active!'
      return
    end
    
    redirect_to root_url, notice: 'Verificaion failed!'
  end

  def show
    
  end

  private
  def allowed_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
