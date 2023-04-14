# typed: strict
# frozen_string_literal: true

class PasswordsController < ApplicationController
  extend T::Sig

  sig { returns(String) }
  def create
    user = User.find_by(email: params[:email])

    if user.present?
      user.send_reset_password_instructions!
      render json: { success: true }
    else
      render json: { error: 'This email could not be found.' }, status: :unprocessable_entity
    end
  end

  sig { returns(String) }
  def update
    return invalid_params unless params[:reset_password_token].present? && params[:password].present?

    user = Password.reset_password_with_token!(
      params[:reset_password_token], params[:password]
    )

    if user.present?
      sign_in!(user)
    else
      render json: { error: 'Invalid reset token.' }, status: :unprocessable_entity
    end
  end

  private

  sig { returns(String) }
  def invalid_params
    render json: { error: 'Invalid parameters.' }, status: :unprocessable_entity
  end
end
