class User < ApplicationRecord
  enum status: [:enable, :disable]

  before_save { self.email = email.downcase }

  has_many :articles, dependent: :destroy
  has_many :comments, as: :commentable

  validates :username, presence: true, uniqueness: { case_sensitive: false }, length:  { minimum: 2, maximum: 25 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 105 },
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }

  has_secure_password

  scope :active_users, -> { where status: :enable }
  scope :without_login_since, -> (since_date)  { where("last_login < ?", since_date) }
end
