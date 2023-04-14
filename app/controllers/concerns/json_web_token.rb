# typed: strict
# frozen_string_literal: true

require 'jwt'

module JsonWebToken
  extend T::Sig
  extend ActiveSupport::Concern

  SECRET_KEY = Rails.application.secret_key_base

  sig { params(payload: Hash, exp: Integer).returns(String) }
  def jwt_encode(payload, exp = 7.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  sig { params(token: String).returns(HashWithIndifferentAccess) }
  def jwt_decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
