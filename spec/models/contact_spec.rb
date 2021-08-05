# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, type: :model do
  context 'validations' do
    it 'without name' do
      contact = build(:contact, name: nil)

      expect(contact).to_not be_valid
    end

    it 'without telephone' do
      contact = build(:contact, telephone: nil)

      expect(contact).to_not be_valid
    end

    it 'without user' do
      contact = build(:contact, user: nil)

      expect(contact).to_not be_valid
    end
  end

  context 'creation' do
    it 'when pass all fields required' do
      contact = create(:contact)

      expect(contact).to be_valid
    end
  end
end
