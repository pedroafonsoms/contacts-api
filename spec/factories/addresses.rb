# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    street { FFaker::AddressBR.street }
    number { FFaker::AddressBR.building_number.to_i }
    zip_code { FFaker::AddressBR.zip_code }
    neighborhood { FFaker::AddressBR.neighborhood }
    city { FFaker::AddressBR.city }
    association :contact
  end
end
