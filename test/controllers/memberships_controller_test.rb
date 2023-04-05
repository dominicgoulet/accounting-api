# frozen_string_literal: true

require 'test_helper'

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @membership = memberships(:valid)
  end

  test 'should create membership given valid params' do
    assert_difference('Membership.count') do
      post memberships_url,
           params: {
             membership: {
               user_id: users(:valid).id,
               organization_id: organizations(:valid).id
             }
           }
    end

    assert_response :created
  end

  test 'should not create membership with invalid params' do
    assert_difference('Membership.count', 0) do
      post memberships_url, params: { membership: {} },
                            as: :json
    end

    assert_response :unprocessable_entity
  end

  test 'should update membership given valid params' do
    patch membership_url(@membership), params: { membership: {} }, as: :json
    assert_response :success
  end

  test 'should not update membership with invalid params' do
    patch membership_url(@membership), params: { membership: { user_id: 'invalid-id' } }, as: :json
    assert_response :unprocessable_entity
  end

  test 'should destroy membership' do
    assert_difference('Membership.count', -1) do
      delete membership_url(@membership), as: :json
    end

    assert_response :no_content
  end
end
