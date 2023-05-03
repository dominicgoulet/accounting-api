# typed: strict
# frozen_string_literal: true

class MembershipSerializer
  extend T::Sig
  include Alba::Resource

  root_key :membership

  attributes :id, :user_id, :organization_id, :level
end
