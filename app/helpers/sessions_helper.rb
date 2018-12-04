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

  def find__user__by__session
    if (user_id = session[:user_id])
      @current_user ||= find_user(user_id)
    end
  end

  def find_user_by_cookies
     if(user_id = cookies.signed[:user_id])
       user = find_user(user_id)
       login(user)
     end
  end

  def current_user
    if session[:user_id]
      find__user__by__session
    else
        find_user_by_cookies
    end
  end

  def current_user?(user)
    user == current_user
  end

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
