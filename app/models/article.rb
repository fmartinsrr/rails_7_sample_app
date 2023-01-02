class Article < ApplicationRecord
  validates :title, presence: true, length:  { minimum: 1, maximum: 20 }
  enum status: [:draft, :pending, :live]
  
end