# typed: ignore
# frozen_string_literal: true

require 'test_helper'

class UserMailerTest < ActiveSupport::TestCase
  def setup
    @user = users(:valid)
  end

  test '.new_user sent email' do
    assert UserMailer.with(user: @user).new_user.deliver.is_a? Mail::Message
  end

  test '.invited_user sent email' do
    assert UserMailer.with(user: @user).invited_user.deliver.is_a? Mail::Message
  end

  test '.new_password sent email' do
    assert UserMailer.with(user: @user).new_password.deliver.is_a? Mail::Message
  end

  test '.change_email sent email fails when unconfirmed_email is not present' do
    refute UserMailer.with(user: @user).change_email.deliver.present?
  end

  test '.change_email sent email succeeds when unconfirmed_email is present' do
    assert @user.change_email!('darth.vader2@theempire.org')
    assert UserMailer.with(user: @user).change_email.deliver.present?
  end
end
