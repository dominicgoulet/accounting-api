# typed: strict
# frozen_string_literal: true

class MembershipsController < ApplicationController
  extend T::Sig

  before_action :set_membership, only: %i[show update destroy]

  sig { void }
  def create
    organization = Organization.find_by(id: membership_params[:organization_id])
    user = User.find_by(id: membership_params[:user_id])

    @membership = T.let(Membership.new(user:, organization:), T.nilable(Membership))

    if T.must(@membership).save
      render json: @membership, status: :created, location: @membership
    else
      render json: T.must(@membership).errors, status: :unprocessable_entity
    end
  end

  sig { void }
  def update
    if T.must(@membership).update(membership_params)
      render json: @membership
    else
      render json: T.must(@membership).errors, status: :unprocessable_entity
    end
  end

  sig { void }
  def destroy
    T.must(@membership).destroy
  end

  private

  sig { void }
  def set_membership
    @membership = T.let(Membership.find(params[:id]), T.nilable(Membership))
  end

  sig { returns(ActionController::Parameters) }
  def membership_params
    params.fetch(:membership, {}).permit(:user_id, :organization_id)
  end
end
