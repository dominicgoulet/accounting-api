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

    UserMailer.with(user:).invited_user.deliver_later

    user
  end

  sig { params(auth_info: OmniAuth::AuthHash).returns(User) }
  def self.find_or_create_from_omniauth(auth_info)
    # If an identity already exists with the same provider and uid,
    # we can safely assume that it is the right user
    UserIdentity.find_by(
      provider: auth_info['provider'],
      uid: auth_info['uid']
    ).tap { |identity| return identity.user if identity }

    find_or_create_user_and_associate_identity(auth_info)
  end

  # Private methods

  sig { params(auth_info: OmniAuth::AuthHash).returns(User) }
  private_class_method def self.create_from_omniauth(auth_info)
    user = User.create(
      email: auth_info.dig('info', 'email'),
      password: SecureRandom.urlsafe_base64
    )

    user.send_new_user_instructions! if user.persisted?

    user
  end

  sig { params(auth_info: OmniAuth::AuthHash).returns(User) }
  private_class_method def self.find_or_create_user_and_associate_identity(auth_info)
    # If no identity is found, check if a user with the same email exists
    user = User.find_by(email: auth_info.dig('info', 'email'))

    # If there is no user with the same email, create it.
    user = create_from_omniauth(auth_info) unless user.present?

    if user.persisted?
      user.identities.create!(
        provider: auth_info['provider'],
        uid: auth_info['uid']
      )
    end

    user
  end
end
