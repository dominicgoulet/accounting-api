# typed: strict
# frozen_string_literal: true

module ActionDispatch
  class IntegrationTest
    extend T::Sig

    sig { returns(T.untyped) }
    def json_data
      JSON.parse(response.body).deep_symbolize_keys
    end
  end
end
