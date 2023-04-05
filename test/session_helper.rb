# frozen_string_literal: true

module ActiveSupport
  class TestCase
    include JsonWebToken

    def sign_in!(user)
      @token = jwt_encode(user_id: user.id)
    end

    def default_headers
      {
        'Accept' => 'application/json',
        'Authorization' => @token
      }
    end
  end
end
