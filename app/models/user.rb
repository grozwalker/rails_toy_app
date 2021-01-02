# frozen_string_literal: true

class User < ApplicationRecord
  before_save :downcase_email
  before_create :create_activation_token

  attr_accessor :remember_token, :activation_token, :reset_token

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

  def authenticated?(type, token)
    digest = send("#{type}_digest")

    return false if digest.nil?

    # raise digest.inspect

    BCrypt::Password.new(digest).is_password? token
  end

  def activate!
    update!({
              activated: true,
              activated_at: Time.zone.now
            })
  end

  def send_activation_email
    UserMailer.with(user: self).account_activation.deliver_now
  end

  def send_reset_email
    UserMailer.with(user: self).password_reset.deliver_now
  end

  def create_reset_digest!
    self.reset_token = User.new_token
    update!({
              reset_digest: User.digest(reset_token),
              reset_sent_at: Time.zone.now
            })
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_token
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
