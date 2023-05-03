# typed: strict
# frozen_string_literal: true

require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  extend T::Sig

  setup do
    @user = T.let(users(:valid), T.nilable(User))
    sign_in!(T.must(@user))
  end

  test 'should get current user if signed_in?' do
    get '/registrations', headers: default_headers
    assert_response :ok
  end

  test 'should create a new users given valid params' do
    post '/registrations', params: { user: { email: 'palpatine@theempire.org', password: '0000' } },
                           headers: default_headers
    assert_response :ok
  end

  test 'should not create a new user given invalid params' do
    post '/registrations', params: { user: { email: '' } } # , headers: default_headers
    assert_response :unprocessable_entity
  end

  test 'should update current user given valid params' do
    patch '/registrations', params: { user: { current_password: '0000', first_name: 'Darth', last_name: 'Vader' } },
                            headers: default_headers
    assert_response :ok
  end

  test 'should not update current user given invalid params' do
    patch '/registrations', params: { user: { current_password: '0000', password: '1' } },
                            headers: default_headers
    assert_response :unprocessable_entity
  end

  test 'should confirm for current user given valid confirmation token' do
    patch '/registrations/confirm', params: { confirmation_token: T.must(@user).confirmation_token },
                                    headers: default_headers
    assert_response :ok
  end

  test 'should not confirm for current user given invalid confirmation token' do
    patch '/registrations/confirm', params: { confirmation_token: 'invalid-token' }, headers: default_headers
    assert_response :unprocessable_entity
  end

  test 'should accept invitation for current user given valid confirmation token' do
    patch '/registrations/accept-invitation', params: { confirmation_token: T.must(@user).confirmation_token },
                                              headers: default_headers
    assert_response :ok
  end

  test 'should not accept invitation for current user given invalid confirmation token' do
    patch '/registrations/accept-invitation', params: { confirmation_token: 'invalid-token' }, headers: default_headers
    assert_response :unprocessable_entity
  end

  test 'should cancel email change for current user' do
    patch '/registrations/cancel-email-change', headers: default_headers
    assert_response :ok
  end
end
