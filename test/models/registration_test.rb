# typed: strict
# frozen_string_literal: true

require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  extend T::Sig

  # Class methods
  test '#create_with_random_password returns a new valid User instance' do
    assert Registration.create_with_random_password('emperor@theempire.org').valid?
  end

  test '#find_or_create_with_random_password returns the found user if email is found' do
    assert Registration.find_or_create_with_random_password(users(:valid).email) == users(:valid)
  end

  test '#find_or_create_with_random_password returns a new valid User instance when email is not found' do
    assert Registration.find_or_create_with_random_password('emperor@theempire.org').valid?
  end
end
