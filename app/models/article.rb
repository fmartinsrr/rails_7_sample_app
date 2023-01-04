class Article < ApplicationRecord
  belongs_to :user
  has_many :article_tags
  has_many :tags, through: :article_tags
  validates :title, presence: true, length:  { minimum: 1, maximum: 20 }
  enum status: [:draft, :pending, :live]
end