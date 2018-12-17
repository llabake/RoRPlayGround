module AccountActivationsHelper
  def activate_and_log_user_in
    @user.activate
    log_in @user
    redirect_to @user, flash: { success: "Account activated!" }
  end
end
