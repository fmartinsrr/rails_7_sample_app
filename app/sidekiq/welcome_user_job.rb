class WelcomeUserJob
  include Sidekiq::Job

  def perform(user_id)
    user = User.find(user_id)
    UserNotifierMailer.send_signup_email(user).deliver
  end
end
