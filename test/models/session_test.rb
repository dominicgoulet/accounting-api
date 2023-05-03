# typed: strict
# frozen_string_literal: true

require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  extend T::Sig

  sig { void }
  def setup
    @user = T.let(users(:valid), T.nilable(User))
  end

  # Class methods
  test '#authenticate_with_email_and_password returns the user when email and password are valid' do
    refute Session.authenticate_with_email_and_password(users(:valid).email, 'wrongpassword', '127.0.0.1')
    assert Session.authenticate_with_email_and_password(users(:valid).email, '0000', '127.0.0.1')
  end
end
