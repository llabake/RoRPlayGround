module SessionsHelper
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if session_user
      if (user_id = session_user)
        @current_user ||= find_user(user_id)
      elsif (user_id = cookie_user)
        user = find_user(user_id)
        login(user)
      end
    end
  end

  def current_user?(user)
    user == current_user
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  # Logs out the current user.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  private

  def cookie_user
    cookies.signed[:user_id]
  end

  def session_user
    session[:user_id]
  end

  def login(user)
    if user && user.authenticated?(cookies[:remember_token])
      log_in user
      @current_user = user
    end
  end

  def find_user(user_id)
    User.find_by(id: user_id)
  end

  def user_exists
    User.find_by(email: params[:session][:email].downcase)
  end
end
