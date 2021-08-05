# frozen_string_literal: true

class ContactSerializer < ActiveModel::Serializer
  attributes :name, :telephone
  has_one :address, serializer: AddressSerializer
end
