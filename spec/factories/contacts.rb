# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    name { FFaker::NameBR.name }
    telephone { FFaker::PhoneNumberBR.phone_number }
    association :user
  end
end
