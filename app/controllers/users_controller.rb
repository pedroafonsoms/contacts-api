# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate!, only: %i[show]

  def show
    render json: user, serializer: UserSerializer
  end

  def create
    user = User.new(permitted_params)

    if user.save
      render json: { message: 'User created successfully!' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.permit(:username, :name, :password, :password_confirmation)
  end
end
