# typed: strict
# frozen_string_literal: true

# == Schema Information
#
# Table name: user_identities
#
#  id         :uuid             not null, primary key
#  user_id    :uuid             not null
#  provider   :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserIdentity < ApplicationRecord
  extend T::Sig

  # Associations
  belongs_to :user

  # Validations
  validates :provider, presence: true, inclusion: { in: %w[google_oauth2 facebook] }
  validates :uid, presence: true
end
