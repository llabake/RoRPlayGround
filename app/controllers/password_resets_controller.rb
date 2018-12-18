class PasswordResetsController < ApplicationController
  before_action :get_user_from_token, only: [create]
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  def new
  end

  def create
    if @user
      handle_reset
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      handle_password_change
    else
      render 'edit'
    end
  end

  private

  def get_user_from_token
    @user = User.find_by(email: params[:password_reset][:email].downcase)
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
