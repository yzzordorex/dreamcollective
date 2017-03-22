class UsersController < ApplicationController
  before_action :require_login, only: [:edit, :update, :show]
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
    @user = @current_user
  end

  def update
    if @current_user.update_attributes(allowed_params)
      @current_user.reload
      if @current_user.verified
        redirect_to settings_path
      else
        @current_user.verify_email
        session.delete(:user_id)
        redirect_to login_path
      end
    else
      render :edit
    end
  end
  
  def verify
    @user = User.verifiable(params[:token])
    if @user and @user.verify!
      session[:user_id] = @user.id
      redirect_to settings_url,
                  notice: 'Thanks for verifying your email address. Your account is now active!'
    else
      redirect_to root_url,
                  notice: 'Verificaion failed!'
    end
  end

  def show
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = @current_user
    end
  end

  private
  def allowed_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :username, :real_name, :profile, :location)
  end
end
