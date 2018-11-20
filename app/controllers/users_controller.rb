class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :find_user, only: [:show, :destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = find_user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to @user, notice: 'Welcome to the Sample App!'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to @user, notice: 'Profile updated'
    else
      render 'edit'
    end
  end

  def destroy
    @user = find_user
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  rescue ActiveRecord::NotFound
    flash[:notice] = "User not found"
  end


  private

  def find_user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def logged_in_user
    store_location
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_user
    @user = find_user
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    unless current_user.admin?
      flash[:danger] = 'Admin functionality'
      redirect_to(root_url)
    end
  end
end
