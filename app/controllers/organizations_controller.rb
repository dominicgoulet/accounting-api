# typed: strict
# frozen_string_literal: true

class OrganizationsController < ApplicationController
  extend T::Sig

  before_action :set_organization, only: %i[show update destroy]

  sig { void }
  def index
    organizations = Organization.all

    render json: OrganizationSerializer.new(organizations).serialize
  end

  sig { void }
  def show
    render json: OrganizationSerializer.new(@organization).serialize
  end

  sig { void }
  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      render json: OrganizationSerializer.new(@organization).serialize, status: :created, location: @organization
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  sig { void }
  def update
    if T.must(@organization).update(organization_params)
      render json: OrganizationSerializer.new(@organization).serialize
    else
      render json: T.must(@organization).errors, status: :unprocessable_entity
    end
  end

  sig { void }
  def destroy
    T.must(@organization).destroy
  end

  private

  sig { void }
  def set_organization
    @organization = T.let(Organization.find(params[:id]), T.nilable(Organization))
  end

  sig { returns(ActionController::Parameters) }
  def organization_params
    params.fetch(:organization, {}).permit(:name)
  end
end
