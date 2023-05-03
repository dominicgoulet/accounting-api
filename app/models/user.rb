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
  has_many :identities, class_name: 'UserIdentity'
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
      return false if User.find_by(email: unconfirmed_email)

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

    UserMailer.with(user: self).new_password.deliver_later

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
    return false unless URI::MailTo::EMAIL_REGEXP.match?(new_email)
    return false if new_email == email
    return false if User.find_by(email: new_email)

    update(
      unconfirmed_email: new_email,
      confirmation_sent_at: Time.zone.now,
      confirmation_token: SecureRandom.urlsafe_base64
    )

    UserMailer.with(user: self).change_email.deliver_later

    true
  end

  sig { returns(T::Boolean) }
  def send_new_user_instructions!
    update(
      confirmation_sent_at: Time.zone.now,
      confirmation_token: SecureRandom.urlsafe_base64
    )

    UserMailer.with(user: self).new_user.deliver_later

    true
  end
end
