# typed: strict
# frozen_string_literal: true

class RegistrationsController < ApplicationController
  extend T::Sig

  before_action :authenticate_user!, only: %i[show update cancel_email_change]
  before_action :set_user, only: %i[show update cancel_email_change]

  sig { returns(String) }
  def show
    render json: UserSerializer.new(@user).serialize
  end

  sig { returns(String) }
  def create
    user = User.create(user_params)

    if user.persisted?
      user.send_new_user_instructions!
      sign_in!(user)
    else
      render_errors_for user
    end
  end

  sig { returns(String) }
  def update
    if can_update? && @user.update(user_params)
      render json: { success: true }
    else
      render json: { error: 'There was an error updating your profile.' }, status: :unprocessable_entity
    end
  end

  sig { returns(String) }
  def confirm
    user = User.find_by(confirmation_token: params[:confirmation_token])

    if user.present?
      user.confirm!
      sign_in!(user)
    else
      render json: { error: 'This confirmation token was not a valid one.' }, status: :unprocessable_entity
    end
  end

  sig { returns(String) }
  def accept_invitation
    user = User.find_by(confirmation_token: params[:confirmation_token])

    if user.present?
      user.confirm!
      sign_in!(user)
    else
      render json: { error: 'This confirmation token was not a valid one.' }, status: :unprocessable_entity
    end
  end

  sig { returns(String) }
  def cancel_email_change
    @user.cancel_change_email!
    render json: { success: true }
  end

  private

  sig { void }
  def set_user
    @user = current_user
  end

  sig { returns(ActionController::Parameters) }
  def user_params
    params.fetch(:user, {}).permit(
      :email,
      :first_name,
      :last_name,
      :password
    )
  end

  sig { returns(T::Boolean) }
  def can_update?
    current_password = params.dig(:user, :current_password)
    new_email = params.dig(:user, :email)

    return false unless current_password.present? && @user.can_update_password?(current_password)
    return false if new_email != @user.email && User.find_by(email: new_email).present?

    @user.change_email!(params[:user][:email])
    params[:user].delete(:email)

    true
  end
end
