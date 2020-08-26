# frozen_string_literal: true

class Post < ApplicationRecord
  has_many_attached :images, dependent: :destroy
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 300 }
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
end
