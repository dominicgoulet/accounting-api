# typed: strict
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

class MembershipSerializer
  extend T::Sig
  include Alba::Resource

  root_key :membership

  attributes :id, :user_id, :organization_id, :level
end
