module UsersHelper

  # Returns the Gravatar for the given user.
  def gravatar_for(user, size: 80)
    gravatar_url = get_gravatar_url(size, user)
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def find_user
    @user ||= User.find(params[:id])
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

  def admin_exist
    if User.where(admin: true).count == 2
      flash[:danger] = "You cannot delete the last admin"
      redirect_to(root_url)
    end
  end

  private

  def get_gravatar_url(size, user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  end
end