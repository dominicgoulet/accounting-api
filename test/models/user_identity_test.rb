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
require 'test_helper'

class UserIdentityTest < ActiveSupport::TestCase
  extend T::Sig

  # test "the truth" do
  #   assert true
  # end
end
