# frozen_string_literal: true

# == Schema Information
#
# Table name: memberships
#
#  id                :uuid             not null, primary key
#  user_id           :uuid
#  organization_id   :uuid
#  level             :string
#  confirmed_at      :datetime
#  last_logged_in_at :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Membership < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :organization

  def confirm!
    update(confirmed_at: Time.zone.now) if confirmed_at.blank?
  end
end
