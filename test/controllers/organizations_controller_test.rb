# typed: strict
# frozen_string_literal: true

require 'test_helper'

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  extend T::Sig

  setup do
    @user = T.let(users(:valid), T.nilable(User))
    @organization = organizations(:valid)
  end

  test 'should get index' do
    sign_in!(T.must(@user))

    get organizations_url, headers: default_headers
    assert_response :success
  end

  test 'should create organization given valid params' do
    sign_in!(T.must(@user))

    assert_difference('Organization.count') do
      post organizations_url,
           params: {
             organization: {
               name: 'The Empire'
             }
           },
           headers: default_headers
    end

    assert_response :created
  end

  test 'should not create organization with invalid params' do
    sign_in!(T.must(@user))

    assert_difference('Organization.count', 0) do
      post organizations_url,
           params: {
             organization: { name: '' }
           },
           headers: default_headers
    end

    assert_response :unprocessable_entity
  end

  test 'should show organization' do
    sign_in!(T.must(@user))

    get organization_url(@organization), headers: default_headers
    assert_response :success
  end

  test 'should update organization given valid params' do
    sign_in!(T.must(@user))

    patch organization_url(@organization),
          params: {
            organization: {
              name: 'New Republic'
            }
          },
          headers: default_headers
    assert_response :success
  end

  test 'should not update organization with invalid params' do
    sign_in!(T.must(@user))

    patch organization_url(@organization),
          params: {
            organization: {
              name: ''
            }
          }, headers: default_headers
    assert_response :unprocessable_entity
  end

  test 'should destroy organization' do
    sign_in!(T.must(@user))

    assert_difference('Organization.count', -1) do
      delete organization_url(@organization), headers: default_headers
    end

    assert_response :no_content
  end
end
