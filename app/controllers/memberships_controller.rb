# typed: false
# frozen_string_literal: true

class MembershipsController < ApplicationController
  before_action :set_membership, only: %i[show update destroy]

  # POST /memberships
  def create
    organization = Organization.find_by(id: membership_params[:organization_id])
    user = User.find_by(id: membership_params[:user_id])

    @membership = Membership.new(user:, organization:)

    if @membership.save
      render json: @membership, status: :created, location: @membership
    else
      render json: @membership.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /memberships/1
  def update
    if @membership.update(membership_params)
      render json: @membership
    else
      render json: @membership.errors, status: :unprocessable_entity
    end
  end

  # DELETE /memberships/1
  def destroy
    @membership.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def membership_params
    params.fetch(:membership, {}).permit(:user_id, :organization_id)
  end
end
