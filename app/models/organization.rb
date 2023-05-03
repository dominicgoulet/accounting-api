# typed: strict
# frozen_string_literal: true

# == Schema Information
#
# Table name: organizations
#
#  id                 :uuid             not null, primary key
#  name               :string
#  website            :string
#  setup_completed_at :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Organization < ApplicationRecord
  extend T::Sig

  # Associations
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  # Validations
  validates :name, presence: true

  sig { returns(T::Array[T.nilable(User)]) }
  def members
    memberships.where(level: :member).map(&:user)
  end

  sig { returns(T::Array[T.nilable(User)]) }
  def owners
    memberships.where(level: :owner).map(&:user)
  end

  sig { returns(T::Boolean) }
  def setup_completed!
    update(setup_completed_at: Time.zone.now) if setup_completed_at.blank?
  end

  sig { params(user: User).returns(T::Boolean) }
  def define_owner!(user)
    memberships.find_or_create_by(user:).update(level: :owner)
  end

  sig { params(user: User, level: Symbol).returns(T::Boolean) }
  def add_member!(user, level = :member)
    m = memberships.find_or_create_by(user:, level:)
    m.confirm!
  end

  sig { params(user: User).returns(T::Boolean) }
  def member?(user)
    memberships.find_by(user:).present?
  end

  sig { params(user: User).returns(T::Boolean) }
  def promote!(user)
    m = memberships.find_by(user:, level: %i[admin member])
    return false if m.blank?

    m.update(level: :admin)
  end

  sig { params(user: User).returns(T::Boolean) }
  def demote!(user)
    m = memberships.find_by(user:, level: %i[admin member])
    return false if m.blank?

    m.update(level: :member)
  end

  sig { params(user: User).returns(T::Boolean) }
  def remove_member!(user)
    m = memberships.find_by(user:, level: %i[admin member])
    return false if m.blank?

    m.destroy

    true
  end
end
