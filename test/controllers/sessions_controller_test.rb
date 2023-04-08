# typed: ignore
# frozen_string_literal: true

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:valid)
  end

  test 'should get current session if signed_in?' do
    sign_in!(@user)

    get session_url, as: :json, headers: default_headers
    assert_response :ok
  end

  test 'should not get current session if not signed_in?' do
    get session_url
    assert_response :ok
  end

  test 'should create a new session given valid params' do
    post sessions_url, params: { email: @user.email, password: '0000' }
    assert_response :ok

    assert json_data[:token].present?
  end

  test 'should not create a new session given invalid params' do
    post sessions_url, params: {}
    assert_response :unprocessable_entity
  end

  test 'should update current session' do
    patch session_url
    assert_response :ok
  end

  test 'should delete current session' do
    delete session_url
    assert_response :no_content
  end
end
