module PasswordResetsHelper
  def get_user
    @user = User.find_by(email: params[:email])
  end

  # Confirms a valid user.
  def valid_user
    unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      redirect_to new_password_reset_url, flash: { danger: "Password reset has expired." }
    end
  end

  def handle_reset
    @user.send_reset_details
    redirect_to root_url, flash: { info: "Email sent with password reset instructions" }
  end

  def handle_password_change
    log_in @user
    @user.update_attribute(:reset_digest, nil)
    redirect_to @user, flash: { success: "Password has been reset." }
  end
end
