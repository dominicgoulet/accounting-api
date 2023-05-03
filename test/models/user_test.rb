# typed: strict
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
  extend T::Sig

  sig { void }
  def setup
    @user = T.let(users(:valid), T.nilable(User))
  end

  test 'valid user' do
    assert T.must(@user).valid?
  end

  test 'invalid without email' do
    T.must(@user).email = ''

    refute T.must(@user).valid?
    assert_not_nil T.must(@user).errors[:email]
  end

  test 'invalid without password' do
    T.must(@user).password = nil

    refute T.must(@user).valid?
    assert_not_nil T.must(@user).errors[:password]
  end

  test '.can_update_password? updates password when a valid password is supplied' do
    assert T.must(@user).can_update_password?('0000')
    refute T.must(@user).can_update_password?('1111')
  end

  test '.avatar_url returns a valid URI' do
    assert URI.parse(T.must(@user).avatar_url)
  end

  test '.confirmed? returns wether the user is confirmed or not' do
    refute T.must(@user).confirmed?
    assert T.must(@user).confirm!
    assert T.must(@user).confirmed?

    assert T.must(@user).change_email!('darth.vader2@theempire.org')
    refute T.must(@user).confirmed?

    assert T.must(@user).confirm!
    assert T.must(@user).confirmed?
  end

  test '.send_new_user_instructions! returns true' do
    assert T.must(@user).send_new_user_instructions!
  end

  test '.change_email! fails with invalid email' do
    refute T.must(@user).change_email!('darth.vader')
    refute T.must(@user).unconfirmed_email.present?
  end

  test '.change_email! manages unconfirmed_email' do
    assert T.must(@user).change_email!('darth.vader2@theempire.org')
    assert T.must(@user).unconfirmed_email == 'darth.vader2@theempire.org'

    assert T.must(@user).cancel_change_email!
    assert T.must(@user).unconfirmed_email.nil?

    assert T.must(@user).change_email!('darth.vader2@theempire.org')
    assert T.must(@user).confirm!
    assert T.must(@user).email == 'darth.vader2@theempire.org'
    assert T.must(@user).unconfirmed_email.nil?
  end

  test '.send_reset_password_instructions! sets a new password reset token and returns true' do
    assert T.must(@user).send_reset_password_instructions!
    assert T.must(@user).reset_password_token.present?
  end
end
