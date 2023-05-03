# typed: strict
# frozen_string_literal: true

require 'test_helper'

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  extend T::Sig

  setup do
    @user = T.let(users(:valid), T.nilable(User))
    @membership = T.let(memberships(:valid), T.nilable(Membership))

    sign_in!(T.must(@user))
  end

  test 'should create membership given valid params' do
    assert_difference('Membership.count') do
      post memberships_url,
           params: {
             membership: {
               user_id: users(:valid).id,
               organization_id: organizations(:valid).id
             }
           },
           headers: default_headers
    end

    assert_response :created
  end

  test 'should not create membership with invalid params' do
    assert_difference('Membership.count', 0) do
      post memberships_url,
           params: {
             membership: {
               user_id: users(:valid).id,
               organization_id: ''
             }
           },
           headers: default_headers
    end

    assert_response :unprocessable_entity
  end

  test 'should update membership given valid params' do
    patch membership_url(@membership),
          params: {
            membership: {
              user_id: T.must(@membership).user_id,
              organization_id: T.must(@membership).organization_id
            }
          },
          headers: default_headers

    assert_response :success
  end

  test 'should not update membership with invalid params' do
    patch membership_url(@membership),
          params: {
            membership: {
              user_id: 'invalid-id'
            }
          },
          headers: default_headers

    assert_response :unprocessable_entity
  end

  test 'should destroy membership' do
    assert_difference('Membership.count', -1) do
      delete membership_url(@membership),
             headers: default_headers
    end

    assert_response :no_content
  end
end
