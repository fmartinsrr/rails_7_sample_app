class User < ApplicationRecord
  validates :username, presence: true, length:  { minimum: 2, maximum: 10 }
end
