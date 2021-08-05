# frozen_string_literal: true

class ContactsController < ApplicationController
  before_action :authenticate!

  def index
    contacts = Contact.where(user: user)

    if contacts.empty?
      render json: { message: 'User no contacts yet!' }, status: :not_found
    else
      render json: contacts, each_serializer: ContactSerializer
    end
  end

  def create
    contact = Contact.new(contact_params)

    if contact.build_address(address_params).validate
      if contact.save
        render json: { message: 'Contact saved with successfully!' }
      else
        render json: { errors: contact.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: 'Required field for address not entered!' }, status: :unprocessable_entity
    end
  end

  def destroy
    contact = Contact.where(id: params[:id], user: user)

    if contact.empty?
      render json: { error: "Contact for user #{user.username} not founded!" }, status: :not_found and return
    end

    if contact.destroy_all
      render json: { message: 'Contact destroyed!' }
    else
      render json: { errors: contact.errrors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    contact = Contact.find_by(id: params[:id], user: user)

    if contact.nil?
      render json: { error: "Contact for user #{user.username} not founded!" }, status: :not_found and return
    end

    if contact.update(contact_params) && contact.address.update(address_params)
      render json: { message: 'Contact updated successfully!' }
    else
      render json: { errors: contact.errrors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.permit(:name, :telephone).merge(user: user)
  end

  def address_params
    params.require(:address).permit(:street, :number, :zip_code, :neighborhood, :city)
  end
end
