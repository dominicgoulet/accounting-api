# frozen_string_literal: true

require 'test_helper'

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @membership = memberships(:valid)
  end

  test 'should create membership' do
    assert_difference('Membership.count') do
      post memberships_url, params: { membership: { user: users(:valid), organization: organizations(:valid) } },
                            as: :json
    end

    assert_response :created
  end

  test 'should update membership' do
    patch membership_url(@membership), params: { membership: {} }, as: :json
    assert_response :success
  end

  test 'should destroy membership' do
    assert_difference('Membership.count', -1) do
      delete membership_url(@membership), as: :json
    end

    assert_response :no_content
  end
end
