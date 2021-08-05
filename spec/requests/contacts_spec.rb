# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Contacts', type: :request do
  describe 'GET /users' do
    context 'when user have contacts' do
      let(:user) do
        user_attributes = attributes_for(:user)
        create(:contact, user: create(:user, user_attributes))
        create(:address).contact

        user_attributes
      end

      before { get contacts_path, headers: headers(authenticate(user[:username], user[:password])) }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns an array' do
        expect(json).to be_kind_of Array
      end

      it 'returns at least one object' do
        expect(json.empty?).to be_falsy
      end
    end

    context 'when user not have contacts' do
      let(:user) do
        user_attributes = attributes_for(:user)
        create(:user, user_attributes)

        user_attributes
      end

      before { get contacts_path, headers: headers(authenticate(user[:username], user[:password])) }

      it 'returns http not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the message "User no contacts yet!"' do
        expect(json['message']).to eql('User no contacts yet!')
      end
    end

    context 'when user is not informed' do
      before { get contacts_path }

      it 'returns http forbidden' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns the message "Token not provided!"' do
        expect(json['errors']).to eql('Token not provided!')
      end
    end
  end

  describe 'POST /users/:user_id/contacts' do
    let(:payload) { attributes_for_contact.merge(address: attributes_for_address) }

    context 'when pass all required fields' do
      before { post contacts_path, params: payload, headers: headers(authenticate(user[:username], user[:password])) }

      let(:user) do
        user_attributes = attributes_for(:user)
        create(:user, user_attributes)

        user_attributes
      end

      let(:attributes_for_address) { attributes_for(:address) }

      let(:attributes_for_contact) { attributes_for(:contact) }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the message "Contact saved with successfully!"' do
        expect(json['message']).to eql('Contact saved with successfully!')
      end

      it 'create the record' do
        expect(Contact.last).to be_truthy
      end
    end

    context 'when some contact required field not passed' do
      before { post contacts_path, params: payload, headers: headers(authenticate(user[:username], user[:password])) }

      let(:user) do
        user_attributes = attributes_for(:user)
        create(:user, user_attributes)

        user_attributes
      end

      let(:attributes_for_address) { attributes_for(:address) }

      let(:attributes_for_contact) { attributes_for(:contact, name: nil) }

      it 'returns https unrpocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the message "Name can\'t be blank"' do
        expect(json['errors']).to include('Name can\'t be blank')
      end

      it 'not create the record' do
        expect(Contact.last).to be_falsy
      end
    end

    context 'when some address required field not passed' do
      before { post contacts_path, params: payload, headers: headers(authenticate(user[:username], user[:password])) }

      let(:user) do
        user_attributes = attributes_for(:user)
        create(:user, user_attributes)

        user_attributes
      end

      let(:attributes_for_address) { attributes_for(:address, street: nil) }

      let(:attributes_for_contact) { attributes_for(:contact) }

      it 'returns https unrpocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the message "Required field for address not entered!"' do
        expect(json['errors']).to eql('Required field for address not entered!')
      end

      it 'not create the record' do
        expect(Contact.last).to be_falsy
      end
    end

    context 'when user is not informed' do
      before { post contacts_path, params: payload }

      let(:attributes_for_address) { attributes_for(:address) }

      let(:attributes_for_contact) { attributes_for(:contact) }

      it 'returns http forbidden' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns the message "Token not provided!"' do
        expect(json['errors']).to eql('Token not provided!')
      end
    end
  end

  describe 'PUT /users/:user_id/contacts/:id' do
    let(:user_attributes) { attributes_for(:user) }

    let(:attributes_creation_address) { attributes_for(:address) }
    let(:attributes_creation_contact) { attributes_for(:contact) }

    let(:contact) do
      contact = create(:contact, attributes_creation_contact.merge(user: create(:user, user_attributes)))
      create(:address, attributes_creation_address.merge(contact: contact))

      contact
    end

    context 'when update some contact field' do
      let(:attributes_update_contact) { attributes_for(:contact) }

      let(:payload) do
        attributes_creation_contact.merge(attributes_update_contact, address: attributes_creation_address)
      end

      before do
        put contact_path(id: contact.id), params: payload,
                                          headers: headers(authenticate(user_attributes[:username],
                                                                        user_attributes[:password]))
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the message "Contact updated successfully!"' do
        expect(json['message']).to eql('Contact updated successfully!')
      end

      it 'updated the record' do
        expect(contact.reload).to have_attributes(attributes_update_contact)
      end
    end

    context 'when update some address field' do
      let(:attributes_update_address) { attributes_for(:address) }

      let(:payload) do
        attributes_creation_contact.merge(address: attributes_creation_address.merge(attributes_update_address))
      end

      before do
        put contact_path(id: contact.id), params: payload,
                                          headers: headers(authenticate(user_attributes[:username],
                                                                        user_attributes[:password]))
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the message "Contact updated successfully!"' do
        expect(json['message']).to eql('Contact updated successfully!')
      end

      it 'updated the record' do
        expect(contact.address.reload).to have_attributes(attributes_update_address)
      end
    end

    context 'when update contact and address fields' do
      let(:attributes_update_address) { attributes_for(:address) }
      let(:attributes_update_contact) { attributes_for(:contact) }

      let(:payload) do
        attributes_creation_contact.merge(attributes_update_contact,
                                          address: attributes_creation_address.merge(attributes_update_address))
      end

      before do
        put contact_path(id: contact.id), params: payload,
                                          headers: headers(authenticate(user_attributes[:username],
                                                                        user_attributes[:password]))
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the message "Contact updated successfully!"' do
        expect(json['message']).to eql('Contact updated successfully!')
      end

      it 'updated the record' do
        expect(contact.address.reload).to have_attributes(attributes_update_address)
        expect(contact.reload).to have_attributes(attributes_update_contact)
      end
    end

    context 'when user is not informed' do
      let(:attributes_update_address) { attributes_for(:address) }
      let(:attributes_update_contact) { attributes_for(:contact) }

      let(:payload) do
        attributes_creation_contact.merge(attributes_update_contact,
                                          address: attributes_creation_address.merge(attributes_update_address))
      end

      before { put contact_path(id: contact.id), params: payload }

      it 'returns http forbidden' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns the message "Token not provided!"' do
        expect(json['errors']).to eql('Token not provided!')
      end

      it 'not updated the record' do
        expect(contact.reload).to have_attributes(attributes_creation_contact)
        expect(contact.address.reload).to have_attributes(attributes_creation_address)
      end
    end

    context 'when contact not exists' do
      let(:attributes_update_address) { attributes_for(:address) }
      let(:attributes_update_contact) { attributes_for(:contact) }

      let(:payload) do
        attributes_creation_contact.merge(attributes_update_contact,
                                          address: attributes_creation_address.merge(attributes_update_address))
      end

      before do
        contact = create(:contact, attributes_creation_contact.merge(user: create(:user, user_attributes)))
        create(:address, attributes_creation_address.merge(contact: contact))

        put contact_path(id: 0), params: payload,
                                 headers: headers(authenticate(user_attributes[:username], user_attributes[:password]))
      end

      it 'returns http not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the message "Contact for user XXX not founded!"' do
        expect(json['error']).to eql("Contact for user #{User.last.username} not founded!")
      end

      it 'not updated the record' do
        expect(Contact.last).to have_attributes(attributes_creation_contact)
        expect(Contact.last.address).to have_attributes(attributes_creation_address)
      end
    end
  end

  describe 'DELETE /users/:user_id/contacts/:id' do
    context 'when all required fields have been passed' do
      let(:contact) { create(:contact, user: create(:user, user_attributes)) }

      let(:user_attributes) { attributes_for(:user) }

      before do
        delete contact_path(id: contact.id),
               headers: headers(authenticate(user_attributes[:username], user_attributes[:password]))
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the message "Contact destroyed!"' do
        expect(json['message']).to eql('Contact destroyed!')
      end

      it 'destroy the record' do
        expect(Contact.last).to be_nil
      end
    end

    context 'when user not informed' do
      let(:contact) { create(:contact, user: create(:user, user_attributes)) }

      let(:user_attributes) { attributes_for(:user) }

      before { delete contact_path(id: contact.id) }

      it 'returns http forbidden' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns the message "Token not provided!"' do
        expect(json['errors']).to eql('Token not provided!')
      end

      it 'not destroy the record' do
        expect(Contact.last.id).to be(contact.id)
      end
    end

    context 'when contact not exists' do
      let(:user_attributes) { attributes_for(:user) }

      before do
        create(:contact, user: create(:user, user_attributes))

        delete contact_path(id: 0),
               headers: headers(authenticate(user_attributes[:username], user_attributes[:password]))
      end

      it 'returns http not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the message "Contact for user X not founded!"' do
        expect(json['error']).to eql("Contact for user #{User.last.username} not founded!")
      end
    end
  end
end
