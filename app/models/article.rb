module ArticleSlug
  def to_param
    "#{id}-#{slug.nil? ? title.to_s.parameterize : slug }"
  end

  private
  def set_slug
    self.slug = title.to_s.parameterize
  end 
end

class Article < ApplicationRecord
  include ArticleSlug
  after_validation :set_slug, only: [:create, :update]

  self.locking_column = :update_count

  belongs_to :user
  has_many :article_tags
  has_many :tags, through: :article_tags
  has_many :comments, as: :commentable

  validates :title, presence: true, length:  { minimum: 1, maximum: 20 }
  enum status: [:draft, :pending, :live]

  scope :filter_by_status, -> (status)  { where status: status }
  scope :filter_by_user, -> (user_id)  { where user_id: user_id }
  scope :filter_by_tag, -> (tag_id)  { joins(:article_tags).where(article_tags: {tag_id: tag_id}) }
  scope :filter_by_status_and_user, -> (status, user_id)  { where status: status, user_id: user_id }
end