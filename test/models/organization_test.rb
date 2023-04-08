# typed: ignore
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
require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  def setup
    @organization = organizations(:valid)
  end

  test 'valid organization' do
    assert @organization.valid?
  end

  test 'invalid without a name' do
    @organization.name = nil

    refute @organization.valid?
    assert_not_nil @organization.errors[:name]
  end

  test '.setup_completed! sets a setup_completed_at and returns true' do
    assert @organization.setup_completed_at.blank?
    assert @organization.setup_completed!
    assert @organization.setup_completed_at.present?
  end

  test '.define_owner! adds user as the owner and returns true' do
    assert_difference('@organization.owners.size', 1) do
      assert @organization.define_owner!(users(:valid))
    end
  end

  test '.add_member! and .remove_member! adds and removes user as a member' do
    user = users(:valid)
    @organization.memberships.delete_all

    assert_difference('@organization.members.size', 1) do
      assert @organization.add_member!(user)
    end

    assert_difference('@organization.members.size', -1) do
      assert @organization.remove_member!(user)
    end
  end

  test '.member? returns true if the user is a member, false otherwise' do
    user = users(:valid)
    @organization.memberships.delete_all

    refute @organization.member?(user)
    @organization.add_member!(user)
    assert @organization.member?(user)
  end

  test '.promote! and .demote! changes the level of the membership between member and admin' do
    user = users(:valid)
    @organization.add_member!(user)
    membership = @organization.memberships.find_by(user:)

    assert membership.level == 'member'
    @organization.promote!(user)
    membership.reload
    assert membership.level == 'admin'

    @organization.demote!(user)
    membership.reload
    assert membership.level == 'member'
  end
end
