# typed: strict
# frozen_string_literal: true

class OmniauthController < ApplicationController
  extend T::Sig

  sig { void }
  def start
    provider = {
      facebook: 'facebook',
      google: 'google_oauth2'
    }[params['provider'].to_sym]

    render html: Repost::Senpai.perform("/auth/#{provider}").html_safe,
           status: :ok
  end

  sig { void }
  def create
    user = Registration.find_or_create_from_omniauth(request.env['omniauth.auth'])

    if user.persisted?
      redirect_to "http://localhost:5173/auth/?token=#{jwt_encode(user_id: user.id)}", allow_other_host: true
    else
      render_errors_for user
    end
  end

  sig { void }
  def failure
    render json: { error: params[:message] }
  end
end
