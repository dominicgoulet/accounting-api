# typed: strict
# frozen_string_literal: true

class ApplicationController < ActionController::API
  extend T::Sig
  include JsonWebToken

  before_action :authenticate_request

  sig { returns(T.nilable(User)) }
  attr_reader :current_user

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'Record not found.' }, status: :not_found
  end

  sig { returns(T::Boolean) }
  def signed_in?
    @current_user.present?
  end

  sig { params(user: User).returns(T.nilable(String)) }
  def sign_in!(user)
    token = jwt_encode(user_id: user.id)
    render json: { token: }, status: :ok
  end

  sig { returns(T::Boolean) }
  def sign_out!
    # Expire/Destroy JWT
    true
  end

  sig { void }
  def authenticate_user!
    render json: { error: 'Not authorized.' }, status: :unauthorized unless signed_in?
  end

  sig { params(object: Object).returns(String) }
  def render_errors_for(object)
    render json: object.errors.to_json, status: :unprocessable_entity
  end

  private

  sig { void }
  def authenticate_request
    header = request.headers['Authorization']
    return unless header

    header = header.split.last
    decoded = jwt_decode(header)
    @current_user = User.find(decoded[:user_id])
  end
end
