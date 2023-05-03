# typed: strict
# frozen_string_literal: true

class RegistrationsController < ApplicationController
  extend T::Sig

  before_action :authenticate_user!, only: %i[show update cancel_email_change]

  sig { void }
  def show
    render json: UserSerializer.new(T.must(current_user)).serialize
  end

  sig { void }
  def create
    user = User.create(create_attributes)

    if user.persisted?
      user.send_new_user_instructions!
      sign_in!(user)
    else
      render_errors_for user
    end
  end

  sig { void }
  def update
    T.must(current_user).change_email!(user_params.email) if user_params.email

    if T.must(current_user).update(update_attributes)
      render json: { success: true }
    else
      render_errors_for T.must(current_user)
    end
  end

  sig { void }
  def confirm
    user = User.find_by(confirmation_token: confirmations_params.confirmation_token)

    if user.present?
      user.confirm!
      sign_in!(user)
    else
      render json: { error: 'This confirmation token is invalid.' }, status: :unprocessable_entity
    end
  end

  sig { void }
  def accept_invitation
    user = User.find_by(confirmation_token: confirmations_params.confirmation_token)

    if user.present?
      user.confirm!
      sign_in!(user)
    else
      render json: { error: 'This confirmation token is invalid.' }, status: :unprocessable_entity
    end
  end

  sig { void }
  def cancel_email_change
    T.must(current_user).cancel_change_email!
    render json: { success: true }
  end

  private

  sig { returns(T::Hash[Symbol, String]) }
  def create_attributes
    {
      email: user_params.email,
      first_name: user_params.first_name,
      last_name: user_params.last_name,
      password: user_params.password
    }
  end

  sig { returns(T::Hash[Symbol, String]) }
  def update_attributes
    {
      first_name: user_params.first_name,
      last_name: user_params.last_name
    }.merge(
      should_update_password? ? { password: user_params.password } : {}
    )
  end

  sig { returns(T::Boolean) }
  def should_update_password?
    T.must(current_user).can_update_password?(T.must(user_params.current_password)) && user_params.password.present?
  end

  #
  # UserParams
  #

  class UserParams < T::Struct
    const :email, T.nilable(String)
    const :first_name, T.nilable(String)
    const :last_name, T.nilable(String)
    const :password, T.nilable(String)
    const :current_password, T.nilable(String)
  end

  sig { returns(UserParams) }
  def user_params
    TypedParams[UserParams].new.extract!(params.fetch(:user))
  end

  #
  # ConfirmationParams
  #

  class ConfirmationParams < T::Struct
    const :confirmation_token, T.nilable(String)
  end

  sig { returns(ConfirmationParams) }
  def confirmations_params
    TypedParams[ConfirmationParams].new.extract!(params)
  end
end
