class User < ApplicationRecord
  has_secure_password
  attr_accessor :remember_token
  VALID_EMAIL_REGEX = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/.freeze

  has_many :taught_courses, class_name: 'Course', foreign_key: 'author_id', dependent: :destroy

  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false }
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }
  validates :full_name, presence: true
  validates :password, presence: true, length: { minimum: 6 }

  # remember a user
  def remember
    self.remember_token = SecureRandom.urlsafe_base64
    digest = Digest::SHA256.base64digest remember_token
    update(remember_digest: digest)
  end

  # authenticate with token
  def authenticated?(remember_token)
    return false if remember_digest.nil?

    Digest::SHA256.base64digest(remember_token) == remember_digest
  end

  # Forgets a user.
  def forget
    update(remember_digest: nil)
  end
end
