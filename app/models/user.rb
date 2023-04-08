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
class User < ApplicationRecord
  extend T::Sig

  # BCrypt
  has_secure_password

  # Associations
  has_many :memberships
  has_many :organizations, through: :memberships

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 4 }, if: ->(obj) { obj.new_record? || obj.password.present? }

  sig { params(current_password: String).returns(T::Boolean) }
  def can_update_password?(current_password)
    return false unless authenticate(current_password)

    true
  end

  sig { returns(String) }
  def avatar_url
    "//www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?d=identicon"
  end

  sig { returns(T::Boolean) }
  def confirm!
    if unconfirmed_email.present?
      update(
        confirmed_at: Time.zone.now,
        email: unconfirmed_email,
        unconfirmed_email: nil
      )
    elsif confirmed_at.blank?
      update(confirmed_at: Time.zone.now)
    end
  end

  sig { returns(T::Boolean) }
  def confirmed?
    confirmed_at.present? && unconfirmed_email.blank?
  end

  sig { returns(T::Boolean) }
  def send_reset_password_instructions!
    update(
      reset_password_sent_at: Time.zone.now,
      reset_password_token: SecureRandom.urlsafe_base64
    )

    UserMailer.new_password(id).deliver_later

    true
  end

  sig { returns(T::Boolean) }
  def cancel_change_email!
    return false unless unconfirmed_email.present?

    update(
      unconfirmed_email: nil,
      confirmation_sent_at: Time.zone.now
    )
  end

  sig { params(new_email: T.nilable(String)).returns(T::Boolean) }
  def change_email!(new_email)
    return false if new_email == email

    update(
      unconfirmed_email: new_email,
      confirmation_sent_at: Time.zone.now,
      confirmation_token: SecureRandom.urlsafe_base64
    )

    UserMailer.change_email(id).deliver_later

    true
  end

  sig { returns(T::Boolean) }
  def send_new_user_instructions!
    update(
      confirmation_sent_at: Time.zone.now,
      confirmation_token: SecureRandom.urlsafe_base64
    )

    UserMailer.new_user(id).deliver_later

    true
  end

  #
  # Class methods
  #

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

  sig { params(token: String, password: String).returns(T.nilable(User)) }
  def self.reset_password_with_token!(token, password)
    user = User.find_by(reset_password_token: token)
    return unless user&.update(password:)

    user
  end

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
