# frozen_string_literal: true

class RegistrationsController < ApplicationController
  before_action :authenticate_user!, only: %i[show update cancel_email_change]
  before_action :set_user, only: %i[show update cancel_email_change]

  # GET /registrations
  def show
    render json: @user.to_json
  end

  # POST /registrations
  def create
    user = User.create(user_params)

    if user.persisted?
      user.send_new_user_instructions!
      sign_in!(user)
    else
      render_errors_for user
    end
  end

  # PATCH /registrations
  def update
    if can_update? && @user.update(user_params)
      render json: { success: true }
    else
      render json: { error: 'There was an error updating your profile.' }, status: :unprocessable_entity
    end
  end

  # PATCH /registrations/confirm
  def confirm
    user = User.find_by(confirmation_token: params[:confirmation_token])

    if user.present?
      user.confirm!
      sign_in!(user)
    else
      render json: { error: 'This confirmation token was not a valid one.' }, status: :unprocessable_entity
    end
  end

  # PATCH /registrations/accept-invitation
  def accept_invitation
    user = User.find_by(confirmation_token: params[:confirmation_token])

    if user.present?
      user.confirm!
      sign_in!(user)
    else
      render json: { error: 'This confirmation token was not a valid one.' }, status: :unprocessable_entity
    end
  end

  # PATCH /registrations/cancel-email-change
  def cancel_email_change
    @user.cancel_change_email!
    render json: { success: true }
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.fetch(:user, {}).permit(
      :email,
      :first_name,
      :last_name,
      :password
    )
  end

  def can_update?
    current_password = params.dig(:user, :current_password)
    new_email = params.dig(:user, :email)

    return false unless @user.can_update_password?(current_password)
    return false if new_email != @user.email && User.find_by(email: new_email).present?

    @user.change_email!(params[:user][:email])
    params[:user].delete(:email)

    true
  end
end
