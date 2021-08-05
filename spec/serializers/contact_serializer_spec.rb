# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactSerializer, type: :serializer do
  subject { described_class.new(model).as_json }

  let(:model) do
    contact = create(:contact)
    create(:address, contact: contact)

    contact
  end

  it 'contains expected attributes' do
    expect(subject).to include(:name, :telephone, :address)
  end

  describe 'data in attribute' do
    it { expect(subject[:name]).to eql(model.name) }
    it { expect(subject[:telephone]).to eql(model.telephone) }
  end

  describe 'no data in attribute' do
    let(:model) { create(:contact) }

    it 'address' do
      expect(subject[:address]).to be_nil
    end
  end
end
