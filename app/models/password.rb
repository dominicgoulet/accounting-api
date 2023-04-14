# typed: strict
# frozen_string_literal: true

class Password
  extend T::Sig

  sig { params(token: String, password: String).returns(T.nilable(User)) }
  def self.reset_password_with_token!(token, password)
    user = User.find_by(reset_password_token: token)
    return unless user&.update(password:)

    user
  end
end
