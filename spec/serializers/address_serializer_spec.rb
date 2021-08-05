# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddressSerializer, type: :serializer do
  let(:model) { create(:address) }
  subject { described_class.new(model).as_json }

  it 'contains expected attributes' do
    expect(subject).to include(:street, :number, :zip_code, :neighborhood, :city)
  end

  describe 'data in attribute' do
    it { expect(subject[:street]).to eql(model.street) }
    it { expect(subject[:number]).to eql(model.number) }
    it { expect(subject[:zip_code]).to eql(model.zip_code) }
    it { expect(subject[:neighborhood]).to eql(model.neighborhood) }
    it { expect(subject[:city]).to eql(model.city) }
  end
end
