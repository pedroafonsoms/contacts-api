# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'POST /sessions' do
    before { post sessions_path, params: attributes_user }

    context 'when user exists' do
      context 'password is valid' do
        let(:attributes_user) do
          attributes = attributes_for(:user)
          create(:user, attributes)

          attributes.deep_symbolize_keys.extract!(:username, :password)
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'returns token' do
          expect(json['token']).not_to be_empty
        end
      end

      context 'password is invalid' do
        let(:attributes_user) do
          attributes = attributes_for(:user)
          create(:user, attributes)

          attributes.deep_symbolize_keys.extract!(:username).merge(password: 'error')
        end

        it 'returns http unprocessable entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns the message "Username or password invalid"' do
          expect(json['errors']).to eql('Username or password invalid')
        end
      end
    end

    context 'when user not exists' do
      let(:attributes_user) { { username: 'error', password: 'error' } }

      it 'returns http unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the message "Username or password invalid"' do
        expect(json['errors']).to eql('Username or password invalid')
      end
    end
  end
end
