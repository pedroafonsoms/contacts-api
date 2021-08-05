# frozen_string_literal: true

class AddressSerializer < ActiveModel::Serializer
  attributes :street, :number, :zip_code, :neighborhood, :city
end
