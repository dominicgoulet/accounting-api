# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :set_user, only: [:show]

  # GET /api/v1/sessions
  def show
    if signed_in?
      render json: { user: @user }.to_json
    else
      render json: { success: false }
    end
  end

  def create
    user = User.authenticate_with_email_and_password(params[:session][:email], params[:session][:password],
                                                     request.remote_ip)

    if user.present?
      sign_in!(user)
    else
      render json: { error: 'Invalid username/password combination.' }, status: :unprocessable_entity
    end
  end

  def update
    render json: { success: true }
  end

  def destroy
    sign_out!
    head :no_content
  end

  private

  def set_user
    @user = current_user
  end
end
