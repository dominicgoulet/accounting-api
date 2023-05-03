# typed: strict
# frozen_string_literal: true

require 'test_helper'

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  extend T::Sig

  setup do
    @user = T.let(users(:valid), T.nilable(User))
  end

  test 'should send reset password instruction given valid params' do
    post passwords_url, params: { email: T.must(@user).email }, as: :json
    assert_response :ok
  end

  test 'should not send reset password instruction given invalid params' do
    post passwords_url, params: { email: 'stormtrooper@theempire.org' }, as: :json
    assert_response :unprocessable_entity
  end

  test 'should reset password given valid params' do
    T.must(@user).send_reset_password_instructions!

    patch passwords_url, params: { reset_password_token: T.must(@user).reset_password_token, password: '1111' },
                         as: :json
    assert_response :ok
  end

  test 'should not reset password given idvalid params' do
    T.must(@user).send_reset_password_instructions!

    patch passwords_url, params: { reset_password_token: 'invalid-token', password: '1111' }, as: :json
    assert_response :unprocessable_entity

    patch passwords_url, params: {}, as: :json
    assert_response :unprocessable_entity
  end
end
