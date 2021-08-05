# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  context 'validations' do
    it 'without contact' do
      address = build(:address, contact: nil)

      expect(address).to_not be_valid
    end

    it 'without street' do
      address = build(:address, street: nil)

      expect(address).to_not be_valid
    end

    it 'without number' do
      address = build(:address, number: nil)

      expect(address).to_not be_valid
    end

    it 'without zip_code' do
      address = build(:address, zip_code: nil)

      expect(address).to_not be_valid
    end

    it 'bad formatted zip_code' do
      address = build(:address, zip_code: '12345000')

      expect(address).to_not be_valid
    end
  end

  context 'creation' do
    it 'when pass all fields required' do
      address = create(:address)

      expect(address).to be_valid
    end
  end
end
