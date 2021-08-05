# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :contact

  validates :zip_code, format: { with: /\d{5}-\d{3}/, message: 'only allows numbers in the format 00000-000' }
  validates :contact, :street, :number, :zip_code, presence: true
end
