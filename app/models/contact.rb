# frozen_string_literal: true

class Contact < ApplicationRecord
  belongs_to :user

  validates :name, :telephone, :user, presence: true

  has_one :address, dependent: :destroy
end
