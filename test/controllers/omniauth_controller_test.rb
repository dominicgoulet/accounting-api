# typed: ignore
# frozen_string_literal: true

require 'test_helper'

class OmniauthControllerTest < ActionDispatch::IntegrationTest
  setup do
    OmniAuth.config.test_mode = true

    %i[facebook google_oauth2].each do |provider|
      OmniAuth.config.mock_auth[provider] = nil
    end
  end

  test 'should render a failure json when there is an error' do
    get '/auth/failure?message=no_authorization_code&strategy=facebook'
    assert_response :ok
  end

  test 'should have a developer omniauth strategy' do
    post '/auth/developer'
    assert_response :found
  end

  test 'should have a facebook omniauth strategy' do
    post '/auth/facebook'
    assert_response :found
  end

  test 'should have a google_oauth2 omniauth strategy' do
    post '/auth/google_oauth2'
    assert_response :found
  end

  test 'should have a facebook omniauth strategy start page for frontend' do
    get '/auth/start/facebook'
    assert_response :ok
  end

  test 'should have a google_oauth2 omniauth strategy start page for frontend' do
    get '/auth/start/google_oauth2'
    assert_response :ok
  end

  test 'should handle proper facebook auth' do
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(auth_hash(:facebook))

    assert_difference -> { User.count } do
      get '/auth/facebook/callback'
      assert_response :found
    end
  end

  test 'should handle proper google_oauth2 auth' do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(auth_hash(:google_oauth2))

    assert_difference -> { User.count } do
      get '/auth/google_oauth2/callback'
      assert_response :found
    end
  end

  test 'should handle proper invalid auth' do
    OmniAuth.config.mock_auth[:invalid] = OmniAuth::AuthHash.new(auth_hash(:invalid))

    assert_no_difference -> { User.count } do
      get '/auth/facebook/callback'
      assert_response :unprocessable_entity
    end
  end

  def auth_hash(provider)
    {}.merge(
      google_oauth2_auth_hash,
      facebook_auth_hash,
      invalid_auth_hash
    )[provider]
  end

  def google_oauth2_auth_hash
    {
      google_oauth2: {
        provider: 'google_oauth2',
        uid: '100000000000000000000',
        info: {
          email: 'joe@bloggs.com'
        }
      }
    }
  end

  def facebook_auth_hash
    {
      facebook: {
        provider: 'facebook',
        uid: '1234567',
        info: {
          email: 'joe@bloggs.com'
        }
      }
    }
  end

  def invalid_auth_hash
    {
      invalid: {
        provider: 'facebook',
        uid: '1234567'
      }
    }
  end
end
