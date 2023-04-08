# typed: ignore
# frozen_string_literal: true

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:valid)
  end

  test 'should send reset password instruction given valid params' do
    post passwords_url, params: { email: @user.email }, as: :json
    assert_response :ok
  end

  test 'should not send reset password instruction given invalid params' do
    post passwords_url, params: { email: 'stormtrooper@theempire.org' }, as: :json
    assert_response :unprocessable_entity
  end

  test 'should reset password given valid params' do
    @user.send_reset_password_instructions!

    patch passwords_url, params: { reset_password_token: @user.reset_password_token, password: '1111' }, as: :json
    assert_response :ok
  end

  test 'should not reset password given idvalid params' do
    @user.send_reset_password_instructions!

    patch passwords_url, params: { reset_password_token: 'invalid-token', password: '1111' }, as: :json
    assert_response :unprocessable_entity

    patch passwords_url, params: {}, as: :json
    assert_response :unprocessable_entity
  end
end
