# typed: ignore
# frozen_string_literal: true

class UserMailerTest < ActiveSupport::TestCase
  def setup
    @user = users(:valid)
  end

  test '.new_user sent email' do
    assert UserMailer.new_user(@user.id).is_a? ActionMailer::MessageDelivery
  end

  test '.invited_user sent email' do
    assert UserMailer.invited_user(@user.id).is_a? ActionMailer::MessageDelivery
  end

  test '.new_password sent email' do
    assert UserMailer.new_password(@user.id).is_a? ActionMailer::MessageDelivery
  end

  test '.change_email sent email' do
    assert UserMailer.change_email(@user.id).is_a? ActionMailer::MessageDelivery
  end
end
