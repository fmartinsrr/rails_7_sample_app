class UserNotifierMailer < ApplicationMailer
  default :from => 'info@sample-app.com'

  def send_signup_email(user)
    @user = user
    mail(:to => @user.email, :subject => 'Welcome to Sample App' )
    # OR:
    # mail(to: @user.email, subject: 'Welcome to Sample App' )
  end
end