# typed: ignore
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
require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  def setup
    @membership = memberships(:valid)
  end

  test 'valid membership' do
    assert @membership.valid?
  end

  test 'invalid without a user' do
    @membership.user = nil

    refute @membership.valid?
    assert_not_nil @membership.errors[:user]
  end

  test 'invalid without an organization' do
    @membership.organization = nil

    refute @membership.valid?
    assert_not_nil @membership.errors[:organization]
  end

  test '.confirm! sets a confirmed_at and returns true' do
    assert @membership.confirmed_at.blank?
    assert @membership.confirm!
    assert @membership.confirmed_at.present?
  end
end
