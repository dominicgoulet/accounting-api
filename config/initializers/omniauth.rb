# typed: ignore
# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development? || Rails.env.test?

  provider :facebook,
           Rails.application.credentials.facebook[:app_id],
           Rails.application.credentials.facebook[:app_secret]

  provider :google_oauth2,
           Rails.application.credentials.google[:client_id],
           Rails.application.credentials.google[:client_secret]
end

# Required to use Omniauth in a Rails API
OmniAuth.config.request_validation_phase = nil
