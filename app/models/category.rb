class Category < ApplicationRecord
  has_many :courses, dependent: :nullify

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
