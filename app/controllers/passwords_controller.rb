# typed: strict
# frozen_string_literal: true

class PasswordsController < ApplicationController
  extend T::Sig

  sig { void }
  def create
    user = User.find_by(email: reset_password_params.email)

    if user.present?
      user.send_reset_password_instructions!
      render json: { success: true }
    else
      render json: { error: 'This email could not be found.' }, status: :unprocessable_entity
    end
  end

  sig { void }
  def update
    user = Password.reset_password_with_token!(
      recover_password_params.reset_password_token,
      recover_password_params.password
    )

    if user.present?
      sign_in!(user)
    else
      render json: { error: 'Invalid reset token.' }, status: :unprocessable_entity
    end
  end

  private

  #
  # ResetPasswordParams
  #

  class ResetPasswordParams < T::Struct
    const :email, String
  end

  sig { returns(ResetPasswordParams) }
  def reset_password_params
    TypedParams[ResetPasswordParams].new.extract!(params)
  end

  #
  # RecoverPasswordParams
  #

  class RecoverPasswordParams < T::Struct
    const :reset_password_token, String
    const :password, String
  end

  sig { returns(RecoverPasswordParams) }
  def recover_password_params
    TypedParams[RecoverPasswordParams].new.extract!(params)
  end
end
