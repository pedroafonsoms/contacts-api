# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    user = User.find_by(username: user_params['username'])

    if user&.authenticate(user_params['password'])
      expiration_time = (Time.zone.now + 1.day).to_i
      payload = { user_id: user.id, username: user.username, exp: expiration_time }

      token = JWT.encode(payload, 'mysecret', 'HS256')
      render json: { username: user.username, token: token }
    else
      render json: { errors: 'Username or password invalid' }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:username, :password)
  end
end
