# typed: strict
# frozen_string_literal: true

class Registration
  extend T::Sig

  sig { params(email: String).returns(User) }
  def self.find_or_create_with_random_password(email)
    User.find_by(email:) || create_with_random_password(email)
  end

  sig { params(email: String).returns(User) }
  def self.create_with_random_password(email)
    user = User.create(
      email:,
      password: SecureRandom.urlsafe_base64,
      confirmation_sent_at: Time.zone.now,
      confirmation_token: SecureRandom.urlsafe_base64,
      reset_password_sent_at: Time.zone.now,
      reset_password_token: SecureRandom.urlsafe_base64
    )

    UserMailer.invited_user(user.id).deliver_later

    user
  end
end
