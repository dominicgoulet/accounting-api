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
  # Associations
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  def members
    memberships.where(level: :member).map(&:user)
  end

  def owners
    memberships.where(level: :owner).map(&:user)
  end

  # Validations
  validates :name, presence: true

  def setup_completed!
    update(setup_completed_at: Time.zone.now) if setup_completed_at.blank?
  end

  def define_owner!(user)
    memberships.find_or_create_by(user:).update(level: :owner)
  end

  def add_member!(user, level = :member)
    m = memberships.find_or_create_by(user:, level:)
    m.confirm!
  end

  def member?(user)
    memberships.find_by(user:).present?
  end

  def promote!(user)
    m = memberships.find_by(user:, level: %i[admin member])
    return if m.blank?

    m.update(level: :admin)
  end

  def demote!(user)
    m = memberships.find_by(user:, level: %i[admin member])
    return if m.blank?

    m.update(level: :member)
  end

  def remove_member!(user)
    m = memberships.find_by(user:, level: %i[admin member])
    return if m.blank?

    m.destroy
  end
end
