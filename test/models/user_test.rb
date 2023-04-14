# typed: ignore
# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :string
#  password_digest        :string
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  sign_in_count          :integer          default(0), not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  first_name             :string
#  last_name              :string
#  setup_completed_at     :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:valid)
  end

  test 'valid user' do
    assert @user.valid?
  end

  test 'invalid without email' do
    @user.email = nil

    refute @user.valid?
    assert_not_nil @user.errors[:email]
  end

  test 'invalid without password' do
    @user.password = nil

    refute @user.valid?
    assert_not_nil @user.errors[:password]
  end

  test '.can_update_password? updates password when a valid password is supplied' do
    assert @user.can_update_password?('0000')
    refute @user.can_update_password?('1111')
  end

  test '.avatar_url returns a valid URI' do
    assert URI.parse(@user.avatar_url)
  end

  test '.confirmed? returns wether the user is confirmed or not' do
    refute @user.confirmed?
    assert @user.confirm!
    assert @user.confirmed?

    assert @user.change_email!('darth.vader2@theempire.org')
    refute @user.confirmed?

    assert @user.confirm!
    assert @user.confirmed?
  end

  test '.send_new_user_instructions! returns true' do
    assert @user.send_new_user_instructions!
  end

  test '.change_email! fails with invalid email' do
    refute @user.change_email!('darth.vader')
    refute @user.unconfirmed_email.present?
  end

  test '.change_email! manages unconfirmed_email' do
    assert @user.change_email!('darth.vader2@theempire.org')
    assert @user.unconfirmed_email == 'darth.vader2@theempire.org'

    assert @user.cancel_change_email!
    assert @user.unconfirmed_email.nil?

    assert @user.change_email!('darth.vader2@theempire.org')
    assert @user.confirm!
    assert @user.email == 'darth.vader2@theempire.org'
    assert @user.unconfirmed_email.nil?
  end

  test '.send_reset_password_instructions! sets a new password reset token and returns true' do
    assert @user.send_reset_password_instructions!
    assert @user.reset_password_token.present?
  end
end
