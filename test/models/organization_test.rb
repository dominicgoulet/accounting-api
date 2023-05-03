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
require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  extend T::Sig

  sig { void }
  def setup
    @organization = T.let(organizations(:valid), T.nilable(Organization))
  end

  test 'valid organization' do
    assert T.must(@organization).valid?
  end

  test 'invalid without a name' do
    T.must(@organization).name = ''

    refute T.must(@organization).valid?
    assert_not_nil T.must(@organization).errors[:name]
  end

  test '.setup_completed! sets a setup_completed_at and returns true' do
    assert T.must(@organization).setup_completed_at.blank?
    assert T.must(@organization).setup_completed!
    assert T.must(@organization).setup_completed_at.present?
  end

  test '.define_owner! adds user as the owner and returns true' do
    assert_difference('T.must(@organization).owners.size', 1) do
      assert T.must(@organization).define_owner!(users(:valid))
    end
  end

  test '.add_member! and .remove_member! adds and removes user as a member' do
    user = users(:valid)
    T.must(@organization).memberships.delete_all

    assert_difference('T.must(@organization).members.size', 1) do
      assert T.must(@organization).add_member!(user)
    end

    assert_difference('T.must(@organization).members.size', -1) do
      assert T.must(@organization).remove_member!(user)
    end
  end

  test '.member? returns true if the user is a member, false otherwise' do
    user = users(:valid)
    T.must(@organization).memberships.delete_all

    refute T.must(@organization).member?(user)
    T.must(@organization).add_member!(user)
    assert T.must(@organization).member?(user)
  end

  test '.promote! and .demote! changes the level of the membership between member and admin' do
    user = users(:valid)
    T.must(@organization).add_member!(user)
    membership = T.let(T.must(@organization).memberships.find_by(user:), T.nilable(Membership))

    assert T.must(membership).level == 'member'
    T.must(@organization).promote!(user)
    T.must(membership).reload
    assert T.must(membership).level == 'admin'

    T.must(@organization).demote!(user)
    T.must(membership).reload
    assert T.must(membership).level == 'member'
  end
end
