# typed: strict
# frozen_string_literal: true

require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  extend T::Sig

  setup do
    @user = T.let(users(:valid), T.nilable(User))
  end

  test 'should get current session if signed_in?' do
    sign_in!(T.must(@user))

    get session_url, headers: default_headers

    assert_response :ok
  end

  test 'should not get current session if not signed_in?' do
    get session_url

    assert_response :unauthorized
  end

  test 'should create a new session given valid params' do
    post sessions_url, params: {
      email: T.must(@user).email,
      password: '0000'
    }

    assert_response :ok
    assert json_data[:token].present?
  end

  test 'should not create a new session given invalid params' do
    post sessions_url, params: {
      email: 'luke@skywalker.edu',
      password: '1234'
    }

    assert_response :unprocessable_entity
  end

  test 'should update current session' do
    sign_in!(T.must(@user))

    patch session_url, headers: default_headers

    assert_response :ok
  end

  test 'should delete current session' do
    sign_in!(T.must(@user))

    delete session_url, headers: default_headers

    assert_response :no_content
  end
end
