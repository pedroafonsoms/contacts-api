# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  let(:user) { create(:user) }
  subject { described_class.new(user).as_json }

  it 'contains expected attributes' do
    expect(subject).to include(:name, :username, :email)
  end

  describe 'data in attribute' do
    it { expect(subject[:name]).to eql(user.name) }
    it { expect(subject[:username]).to eql(user.username) }
    it { expect(subject[:email]).to eql(user.email) }
  end
end
