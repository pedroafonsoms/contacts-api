# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { FFaker::Internet.user_name.remove!('.') }
    password { FFaker::Internet.password }
    password_confirmation { password }
    name { FFaker::NameBR.name }
  end
end
