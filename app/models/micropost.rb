# frozen_string_literal: true

class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  default_scope -> { order(created_at: :desc) }

  validates :user, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: %i[png jpg jpeg]
end
