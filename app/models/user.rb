# frozen_string_literal: true

class User < ApplicationRecord
  before_save :downcase_email
  before_create :create_activation_token

  attr_accessor :remember_token, :activation_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

    BCrypt::Password.create(string, cost: cost)
  end

  # Generate new token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Store remember token to user attribute
  def remember
    self.remember_token = User.new_token
    update!(remember_digest: User.digest(remember_token))
  end

  def forget
    update!(remember_digest: nil)
  end

  def authenticated?(remember_token)
    return false if remember_token.empty?

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_token
    self.activation_token = User.new_token
    self.activation_digest = User.digest(remember_token)
  end
end
