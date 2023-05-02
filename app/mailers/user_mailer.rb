# typed: strict
# frozen_string_literal: true

class UserMailer < ApplicationMailer
  extend T::Sig

  layout 'user_mailer/layouts/default'

  sig { returns(Mail::Message) }
  def new_user
    @user = T.let(params[:user], T.nilable(User))

    mail(to: T.must(@user).email,
         subject: 'Welcome to Ninetyfour!',
         date: Time.zone.now,
         template_path: 'user_mailer',
         template_name: 'new_user')
  end

  sig { returns(Mail::Message) }
  def invited_user
    @user = T.let(params[:user], T.nilable(User))

    mail(to: T.must(@user).email,
         subject: 'You have been invited to join your organization on Ninetyfour!',
         date: Time.zone.now,
         template_path: 'user_mailer',
         template_name: 'invited_user')
  end

  sig { returns(Mail::Message) }
  def new_password
    @user = T.let(params[:user], T.nilable(User))

    mail(to: T.must(@user).email,
         subject: 'Ninetyfour: Forgot password?',
         date: Time.zone.now,
         template_path: 'user_mailer',
         template_name: 'new_password')
  end

  sig { returns(T.nilable(Mail::Message)) }
  def change_email
    @user = T.let(params[:user], T.nilable(User))

    return unless T.must(@user).unconfirmed_email

    mail(to: T.must(@user).email,
         subject: 'Ninetyfour: Change email request',
         date: Time.zone.now,
         template_path: 'user_mailer',
         template_name: 'change_email')
  end
end
