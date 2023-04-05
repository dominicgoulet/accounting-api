# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_request

  attr_reader :current_user

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'Record not found.' }, status: :not_found
  end

  def signed_in?
    @current_user.present?
  end

  def sign_in!(user)
    token = jwt_encode(user_id: user.id)
    render json: { token: }, status: :ok
  end

  def sign_out!
    # Expire/Destroy JWT
  end

  def authenticate_user!
    render json: { error: 'Not authorized.' }, status: :unauthorized unless signed_in?
  end

  def render_errors_for(object)
    render json: object.errors.to_json, status: :unprocessable_entity
  end

  private

  def authenticate_request
    header = request.headers['Authorization']
    return unless header

    header = header.split.last
    decoded = jwt_decode(header)
    @current_user = User.find(decoded[:user_id])
  end
end
