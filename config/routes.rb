# frozen_string_literal: true

Rails.application.routes.draw do
  get '/session', to: 'sessions#show'
  patch '/session', to: 'sessions#update'
  delete '/session', to: 'sessions#destroy'
  resources :sessions, only: [:create]

  patch '/passwords', to: 'passwords#update'
  resources :passwords, only: [:create]

  # Registrations
  get '/registrations', to: 'registrations#show'
  post '/registrations', to: 'registrations#create'
  patch '/registrations', to: 'registrations#update'
  patch '/registrations/confirm', to: 'registrations#confirm'
  patch '/registrations/accept-invitation', to: 'registrations#accept_invitation'
  patch '/registrations/cancel-email-change', to: 'registrations#cancel_email_change'

  resources :passwords, only: [:create, :update]
  resources :organizations, only: [:index, :show, :create, :update, :destroy]
  resources :memberships, only: [:create, :update, :destroy]
end
