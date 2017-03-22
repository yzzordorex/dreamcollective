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
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    @user = logged_in?
    redirect_to login_path unless @user and @user.verified
  end

  def update
    @user = logged_in?
    redirect_to login_path unless @user and @user.verified
    if @user.update_attributes(allowed_params)
      @user.reload
      if @user.verified
        redirect_to settings_path
      else
        @user.verify_email
        session.delete(:user_id)
        redirect_to login_path
      end
    else
      render :edit
    end
  end
  
  def verify
    @user = User.where("token = :token AND token_expires_at > :now AND verified = false",
                       {token: params[:token], now: Time.now}).take!
    if @user and @user.verify!
      # update user, set session, and redirect to /show
      session[:user_id] = @user.id
      redirect_to settings_url, notice: 'Thanks for verifying your email address. Your account is now active!'
    else
      redirect_to root_url, notice: 'Verificaion failed!'
    end
  end

  def show
    redirect_to login_path unless logged_in?
    if params[:id]
      
      @user = User.find(params[:id])
    else
      @user = @current_user
    end
    @user
  end

  private
  def allowed_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :username, :real_name, :profile, :location)
  end
end
