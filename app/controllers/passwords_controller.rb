# frozen_string_literal: true

class PasswordsController < ApplicationController
  # POST /passwords
  def create
    user = User.find_by(email: params[:email])

    if user.present?
      user.send_reset_password_instructions!
      render json: { success: true }
    else
      render json: { error: 'This email could not be found.' }, status: :unprocessable_entity
    end
  end

  # PATCH /passwords/:reset_password_token
  def update
    user = User.reset_password_with_token!(params[:reset_password_token], params[:password])

    if user.present?
      sign_in!(user)
    elsif params[:password].present?
      render json: { error: 'Invalid reset token.' }, status: :unprocessable_entity
    else
      render json: { error: 'Invalid password' }, status: :unprocessable_entity
    end
  end
end
