# typed: strict
# frozen_string_literal: true

class Session
  extend T::Sig

  sig { params(email: String, password: String, sign_in_ip: String).returns(T.nilable(User)) }
  def self.authenticate_with_email_and_password(email, password, sign_in_ip)
    user = User.find_by(email:)
    return unless user&.authenticate(password)

    user.update(
      sign_in_count: user.sign_in_count + 1,
      current_sign_in_ip: sign_in_ip,
      current_sign_in_at: Time.zone.now,
      last_sign_in_at: user.current_sign_in_at,
      last_sign_in_ip: user.last_sign_in_ip
    )

    user
  end
end
