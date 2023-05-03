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
require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  extend T::Sig

  sig { void }
  def setup
    @membership = T.let(memberships(:valid), T.nilable(Membership))
  end

  test 'valid membership' do
    assert T.must(@membership).valid?
  end

  test 'invalid without a user' do
    T.must(@membership).user = nil

    refute T.must(@membership).valid?
    assert_not_nil T.must(@membership).errors[:user]
  end

  test 'invalid without an organization' do
    T.must(@membership).organization = nil

    refute T.must(@membership).valid?
    assert_not_nil T.must(@membership).errors[:organization]
  end

  test '.confirm! sets a confirmed_at and returns true' do
    assert T.must(@membership).confirmed_at.blank?
    assert T.must(@membership).confirm!
    assert T.must(@membership).confirmed_at.present?
  end
end
