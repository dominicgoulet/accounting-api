# frozen_string_literal: true

require 'test_helper'

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:valid)
  end

  test 'should get index' do
    get organizations_url, as: :json
    assert_response :success
  end

  test 'should create organization given valid params' do
    assert_difference('Organization.count') do
      post organizations_url, params: { organization: { name: 'The Empire' } }, as: :json
    end

    assert_response :created
  end

  test 'should not create organization with invalid params' do
    assert_difference('Organization.count', 0) do
      post organizations_url, params: { organization: {} }, as: :json
    end

    assert_response :unprocessable_entity
  end

  test 'should show organization' do
    get organization_url(@organization), as: :json
    assert_response :success
  end

  test 'should update organization given valid params' do
    patch organization_url(@organization), params: { organization: {} }, as: :json
    assert_response :success
  end

  test 'should not update organization with invalid params' do
    patch organization_url(@organization), params: { organization: { name: '' } }, as: :json
    assert_response :unprocessable_entity
  end

  test 'should destroy organization' do
    assert_difference('Organization.count', -1) do
      delete organization_url(@organization), as: :json
    end

    assert_response :no_content
  end
end
