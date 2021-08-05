# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :name, :username, :email
end
