# typed: ignore
# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins %w[
      localhost:3000
      localhost:3001
    ]

    resource '*',
      headers: :any,
      methods: %i[get post put patch delete options head],
      credentials: true
  end
end
