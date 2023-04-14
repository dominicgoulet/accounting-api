# typed: strict
# frozen_string_literal: true

class MembershipsController < ApplicationController
  extend T::Sig

  before_action :set_membership, only: %i[show update destroy]

  sig { returns(String) }
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

  sig { returns(String) }
  def update
    if @membership.update(membership_params)
      render json: @membership
    else
      render json: @membership.errors, status: :unprocessable_entity
    end
  end

  sig { void }
  def destroy
    @membership.destroy
  end

  private

  sig { void }
  def set_membership
    @membership = Membership.find(params[:id])
  end

  sig { returns(ActionController::Parameters) }
  def membership_params
    params.fetch(:membership, {}).permit(:user_id, :organization_id)
  end
end
