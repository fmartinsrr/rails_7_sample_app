class SessionsController < ApplicationController

  def new
  end

  def create
    email = params[:session][:email].downcase
    user = User.find_by(email: email)
    if user && user.authenticate(params[:session][:password])
      # Rails provides a session object which can be access within the session object
      session[:user_id] = user.id
      flash[:notice] = "Logged in successfully."
      redirect_to user
    else
      # It needs to be flash.now to display otherwise it would be waiting for a new http request.
      flash.now[:alert] = "Can't log in user."
      render 'new'
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_url
  end

end