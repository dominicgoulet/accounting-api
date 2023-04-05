# frozen_string_literal: true

require 'test_helper'

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  #
  # We use OrganizationsController just as a mean to test the
  # various common features in ApplicationController.
  #

  setup do
    @organization = organizations(:valid)
  end

  test 'should handle invalid records' do
    get organization_url(id: 'invalid-id'), as: :json
    assert_response :not_found
  end
end
