class Article < ApplicationRecord
  belongs_to :user
  has_many :article_tags
  has_many :tags, through: :article_tags
  validates :title, presence: true, length:  { minimum: 1, maximum: 20 }
  enum status: [:draft, :pending, :live]

  scope :filter_by_status, -> (status)  { where status: status }
  scope :filter_by_user, -> (user_id)  { where user_id: user_id }
  scope :filter_by_tag, -> (tag_id)  { joins(:article_tags).where(article_tags: {tag_id: tag_id}) }
  scope :filter_by_status_and_user, -> (status, user_id)  { where status: status, user_id: user_id }
end