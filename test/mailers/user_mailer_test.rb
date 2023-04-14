# typed: ignore
# frozen_string_literal: true

class UserMailerTest < ActiveSupport::TestCase
  def setup
    @user = users(:valid)
  end

  test '.new_user sent email' do
    assert UserMailer.new_user(@user.id).deliver.is_a? Mail::Message
  end

  test '.invited_user sent email' do
    assert UserMailer.invited_user(@user.id).deliver.is_a? Mail::Message
  end

  test '.new_password sent email' do
    assert UserMailer.new_password(@user.id).deliver.is_a? Mail::Message
  end

  test '.change_email sent email fails when unconfirmed_email is not present' do
    refute UserMailer.change_email(@user.id).deliver.present?
  end

  test '.change_email sent email succeeds when unconfirmed_email is present' do
    assert @user.change_email!('darth.vader2@theempire.org')
    assert UserMailer.change_email(@user.id).deliver.present?
  end
end
