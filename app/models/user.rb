# frozen_string_literal: true

class User < ApplicationRecord
  before_save :normalize_username

  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :password, :password_confirmation, :name, presence: true

  has_many :contacts, dependent: :destroy

  validate :username_validation

  private

  def normalize_username
    self.username = username.downcase
  end

  def username_validation
    errors.add(:username_validation, 'Its not possible use a character special in username (just underscore _)') \
     if username.present? && username[/\W|\d/].present?
  end
end
