# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it 'without username' do
      user = build(:user, username: nil)

      expect(user).to_not be_valid
    end

    it 'without password' do
      user = build(:user, password: nil)

      expect(user).to_not be_valid
    end

    it 'without password_confirmation' do
      user = build(:user, password_confirmation: nil)

      expect(user).to_not be_valid
    end

    it 'without name' do
      user = build(:user, password_confirmation: nil)

      expect(user).to_not be_valid
    end

    it 'username uniqueness' do
      user = build(:user, username: create(:user).username)

      expect(user).to_not be_valid
    end
  end

  context 'creation' do
    it 'when pass all fields required' do
      user = create(:user)

      expect(user).to be_valid
    end

    it 'saved password encrypted' do
      password = '123456789'
      create(:user, password: password)

      expect(User.last.password_digest).not_to eql(password)
    end
  end

  context '#normalize_username' do
    it 'saved username downcase' do
      username = 'UserNamE'
      create(:user, username: username)

      expect(User.last.username).to eql(username.downcase)
    end
  end

  context '#username_validation' do
    it 'username contains special characteres' do
      user = build(:user, username: 'sp&cial')

      expect(user).to_not be_valid
    end
  end
end
