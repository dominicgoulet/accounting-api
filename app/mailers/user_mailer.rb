# typed: strict
# frozen_string_literal: true

class UserMailer < ApplicationMailer
  extend T::Sig

  layout 'user_mailer/layouts/default'

  sig { params(user_id: String).returns(Mail::Message) }
  def new_user(user_id)
    @user = User.find(user_id)

    mail(to: @user.email,
         subject: 'Welcome to Ninetyfour!',
         date: Time.zone.now,
         template_path: 'user_mailer',
         template_name: 'new_user')
  end

  sig { params(user_id: String).returns(Mail::Message) }
  def invited_user(user_id)
    @user = User.find(user_id)

    mail(to: @user.email,
         subject: 'You have been invited to join your organization on Ninetyfour!',
         date: Time.zone.now,
         template_path: 'user_mailer',
         template_name: 'invited_user')
  end

  sig { params(user_id: String).returns(Mail::Message) }
  def new_password(user_id)
    @user = User.find(user_id)

    mail(to: @user.email,
         subject: 'Ninetyfour: Forgot password?',
         date: Time.zone.now,
         template_path: 'user_mailer',
         template_name: 'new_password')
  end

  sig { params(user_id: String).returns(T.nilable(Mail::Message)) }
  def change_email(user_id)
    @user = User.find(user_id)
    return unless @user.unconfirmed_email

    mail(to: @user.unconfirmed_email,
         subject: 'Ninetyfour: Change email request',
         date: Time.zone.now,
         template_path: 'user_mailer',
         template_name: 'change_email')
  end
end
