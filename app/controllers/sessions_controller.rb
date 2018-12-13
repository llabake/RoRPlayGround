class SessionsController < ApplicationController
  before_action :find_user, only: [:create]
  def new
  end

  def create
    user = user_exists
    if user && authenticate_user(user)
      handle_user_authentication(user)
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

  def handle_user_authentication(user)
    if user.activated?
      log_in user
      remember_user(user)
      redirect_back_or user
    else
      message = "Account not activated. "
      message += "Check your email for the activation link."
      redirect_to root_url, flash: { warning:  message }
    end
  end

  def find_user
    @user = User.find_by(email: params[:session][:email].downcase)
  end
end
