# frozen_string_literal: true

Rails.application.routes.draw do
  get 'users', action: :show, controller: 'users'
  resources :users, only: %i[create]

  resources :contacts, only: %i[create index destroy update]
  resources :sessions, only: %i[create]
end
