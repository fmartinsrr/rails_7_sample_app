class Article < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length:  { minimum: 1, maximum: 20 }
  enum status: [:draft, :pending, :live]

end