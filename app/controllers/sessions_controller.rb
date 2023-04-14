# typed: strict
# frozen_string_literal: true

class SessionsController < ApplicationController
  extend T::Sig

  before_action :set_user, only: [:show]

  sig { returns(String) }
  def show
    if signed_in?
      render json: { user: SessionSerializer.new(@user).serialize }.to_json
    else
      render json: { success: false }
    end
  end

  sig { returns(String) }
  def create
    if params[:email].present? && params[:password].present?
      user = Session.authenticate_with_email_and_password(
        params[:email], params[:password], request.remote_ip
      )
    end

    if user.present?
      sign_in!(user)
    else
      render json: { error: 'Invalid username/password combination.' }, status: :unprocessable_entity
    end
  end

  sig { returns(String) }
  def update
    render json: { success: true }
  end

  sig { void }
  def destroy
    sign_out!
  end

  private

  sig { void }
  def set_user
    @user = current_user
  end
end
