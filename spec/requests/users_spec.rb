# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users' do
    context 'when user is informed' do
      let(:user) { create(:user) }

      before { get users_path, headers: headers(authenticate(user.username, user.password)) }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the user searched' do
        expect(json['username']).to eql(user.username)
      end

      it 'returns an object' do
        expect(json).to be_kind_of Hash
      end
    end

    context 'when user is not informed' do
      before { get users_path }

      it 'returns http forbidden' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns message "Token not provided!"' do
        expect(json['errors']).to eql('Token not provided!')
      end
    end
  end

  describe 'POST /users' do
    before { post users_path, params: user_attributes }

    context 'when parameters correct' do
      let(:user_attributes) { attributes_for(:user) }

      it 'returns http created' do
        expect(response).to have_http_status(:created)
      end

      it 'returns message "User created successfully!"' do
        expect(json['message']).to eql('User created successfully!')
      end

      it 'create the record' do
        expect(User.last).to be_truthy
      end
    end

    context 'when some parameter incorrect' do
      let(:user_attributes) { attributes_for(:user, name: nil) }

      it 'returns http unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the proper message' do
        expect(json['errors']).to include('Name can\'t be blank')
      end

      it 'not created the record' do
        expect(User.last).to be_falsy
      end
    end
  end
end
