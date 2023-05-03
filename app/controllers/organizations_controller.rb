# typed: strict
# frozen_string_literal: true

class OrganizationsController < ApplicationController
  extend T::Sig

  before_action :authenticate_user!

  sig { void }
  def index
    organizations = Organization.all

    render json: OrganizationSerializer.new(organizations).serialize
  end

  sig { void }
  def show
    render json: OrganizationSerializer.new(current_organization).serialize
  end

  sig { void }
  def create
    organization = Organization.new(organization_params.as_json)

    if organization.save
      render json: OrganizationSerializer.new(organization).serialize, status: :created, location: organization
    else
      render_errors_for organization
    end
  end

  sig { void }
  def update
    if T.must(current_organization).update(organization_params.as_json)
      render json: OrganizationSerializer.new(current_organization).serialize
    else
      render_errors_for T.must(current_organization)
    end
  end

  sig { void }
  def destroy
    T.must(current_organization).destroy
  end

  private

  sig { returns(T.nilable(Organization)) }
  def current_organization
    @current_organization ||= T.let(Organization.find(params[:id]), T.nilable(Organization))
  end

  #
  # OrganizationParams
  #

  class OrganizationParams < T::Struct
    const :name, T.nilable(String)
  end

  sig { returns(OrganizationParams) }
  def organization_params
    TypedParams[OrganizationParams].new.extract!(params.fetch(:organization))
  end
end
