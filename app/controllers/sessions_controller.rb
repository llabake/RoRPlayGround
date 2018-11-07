class SessionsController < ApplicationController
  before_action :find_user, only: [:create]
  def new
  end

  def create
    if @user&.authenticate(params[:session][:password])
      log_in @user
      redirect_back_or @user
    else
      flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def find_user
    @user = User.find_by(email: params[:session][:email].downcase)
  end
end
