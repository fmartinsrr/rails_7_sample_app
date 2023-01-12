class AddLastLoginToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_login, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
