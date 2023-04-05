# frozen_string_literal: true

Rails.application.routes.draw do
  resources :sessions, only: [:show, :create, :update, :destroy]

  resources :passwords, only: [:show, :create, :update] do
    collection do
      patch :confirm
      patch :accept_invitation
      patch :cancel_email_change
    end
  end

  resources :passwords, only: [:create, :update]
  resources :organizations, only: [:index, :show, :create, :update, :destroy]
  resources :memberships, only: [:create, :update, :destroy]
end
