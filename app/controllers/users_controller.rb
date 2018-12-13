class UsersController < ApplicationController
  include UsersHelper
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,  :admin_exist,    only: :destroy
  before_action :find_user, only: [:show, :destroy, :update, :edit]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    redirect_to root_url and return unless @user.activated?
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      redirect_to root_url, flash: {
          info: "Please check your email to activate your account."
      }
    else
      render 'new', flash: { info:  'An error occurred while creating user' }
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to @user, notice: 'Profile updated'
    else
      render 'edit', flash: { error: 'Profile update failed' }
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, flash: { success: "Successfully deleted user" }
  rescue ActiveRecord::NotFound => e
    flash[:notice] = "User not found"
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
