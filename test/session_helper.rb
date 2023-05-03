# typed: strict
# frozen_string_literal: true

module ActiveSupport
  class TestCase
    extend T::Sig
    include JsonWebToken

    sig { params(user: User).void }
    def sign_in!(user)
      @token = T.let(jwt_encode(user_id: user.id), T.nilable(String))
    end

    sig { returns(T::Hash[T.untyped, T.untyped]) }
    def default_headers
      {
        'Accept' => 'application/json',
        'Authorization' => @token
      }
    end
  end
end
