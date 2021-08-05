# frozen_string_literal: true

class ApplicationController < ActionController::API
  attr_accessor :user

  private

  def authenticate!
    token = request.headers['Authorization']&.gsub!('Bearer ', '')

    render json: { errors: 'Token not provided!' }, status: :forbidden and return unless token

    begin
      user_id = JWT.decode(token, 'mysecret', 'HS256').first['user_id']
      @user = User.find(user_id)
    rescue JWT::VerificationError, JWT::ExpiredSignature
      render json: { errors: 'Token invalid!' }, status: :forbidden and return
    end
  end
end
