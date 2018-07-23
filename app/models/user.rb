class User < ApplicationRecord
  before_save :downcase_email
  validates :name, presence: true,
    length: {maximum: Settings.user_setting.name_maximum_length}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
    length: {maximum: Settings.user_setting.email_maximum_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.user_setting.password_minimum_length}
  has_secure_password

  class << self
  def digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end

  private
  def downcase_email
    self.email = email.downcase
  end
end
