class Course < ApplicationRecord
  paginates_per 9

  # mount_uploader :video_tutorial, VideoUploader

  belongs_to :category
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  has_one_attached :video_tutorial
  has_many_attached :thumbnails

  validates :video_tutorial, presence: true
  validates :video_tutorial, content_type: %w(video/mp4 video/mov)
  validates :thumbnails, presence: true
  validates :thumbnails, content_type: %w(image/jpg image/jpeg image/png)
  validates :title, presence: true, uniqueness: true

  scope :find_course, ->(query) { where('title ILIKE ?', "%#{query}%") }
  scope :paginate, ->(page) { limit = 5; offset(page * limit).limit(limit) }
  scope :categorize, ->(page, category_id) { where(category_id: category_id).page(page) }
end
