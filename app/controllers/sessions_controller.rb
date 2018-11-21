class SessionsController < ApplicationController
  before_action :find_user, only: [:create]
  def new
  end

  def create
    user = user_exists
    if user && authenticate_user(user)
      log_in user
      remember_user(user)
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def find_user
    @user = User.find_by(email: params[:session][:email].downcase)
  end
  
  def authenticate_user(user)
    user.authenticate(params[:session][:password])
  end

  def remember_user(user)
    params[:session][:remember_me] == '1' ? remember(user) : forget(user)
  end
end
