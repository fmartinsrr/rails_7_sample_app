desc "Disables all users who haven't logged in for more than a month."

task disable_inactive_users: [:environment] do
  User.active_users.without_login_since(DateTime.now.prev_month(1)).update_all(status: :disable)
end