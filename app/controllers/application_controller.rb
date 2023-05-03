# typed: strict
# frozen_string_literal: true

class ApplicationController < ActionController::API
  extend T::Sig
  include JsonWebToken

  before_action :authenticate_request

  sig { returns(T.nilable(User)) }
  attr_reader :current_user

  sig { void }
  def initialize
    @current_user = T.let(nil, T.nilable(User))
    super
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'Record not found.' }, status: :not_found
  end

  rescue_from ActionController::BadRequest do
    render json: { error: 'Invalid parameters.' }, status: :unprocessable_entity
  end

  rescue_from ActionController::ParameterMissing do
    render json: { error: 'Missing parameters.' }, status: :unprocessable_entity
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

  sig { params(object: ApplicationRecord).void }
  def render_errors_for(object)
    render json: ApplicationRecordErrorSerializer.new(object.errors).serialize,
           status: :unprocessable_entity
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
