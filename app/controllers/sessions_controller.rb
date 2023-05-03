# typed: strict
# frozen_string_literal: true

class SessionsController < ApplicationController
  extend T::Sig

  before_action :authenticate_user!, only: %i[show update destroy]

  sig { void }
  def show
    render json: SessionSerializer.new(T.must(current_user)).serialize
  end

  sig { void }
  def create
    user = Session.authenticate_with_email_and_password(
      session_params.email,
      session_params.password,
      request.remote_ip
    )

    if user.present?
      sign_in!(user)
    else
      render json: { error: 'Invalid username/password combination.' }, status: :unprocessable_entity
    end
  end

  sig { void }
  def update
    render json: { success: true }
  end

  sig { void }
  def destroy
    sign_out!
  end

  private

  #
  # SessionParams
  #

  class SessionParams < T::Struct
    const :email, String
    const :password, String
  end

  sig { returns(SessionParams) }
  def session_params
    TypedParams[SessionParams].new.extract!(params)
  end
end
