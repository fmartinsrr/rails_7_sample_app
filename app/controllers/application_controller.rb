class ApplicationController < ActionController::Base

  helper_method :current_user, :logged_in?

  def current_user
    # a ||= b means assign b to a if a is null or undefined or false
    # For example like: a += b => a = a + b  THEN: a ||= b => a = a || b OR: a = b unless a 
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

end
