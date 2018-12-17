class AccountActivationsController < ApplicationController
  before_action :find_user_from_url, only :edit
  def edit
    if @user && !@user.activated? && @user.authenticated?(:activation, params[:id])
      activate_and_log_user_in
    else
      redirect_to root_url, flash: { danger: "Invalid activation link" }
    end
  end

  private

  def find_user_from_url
    @user = User.find_by(email: params[:email])
  end
end
