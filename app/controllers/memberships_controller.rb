# typed: strict
# frozen_string_literal: true

class MembershipsController < ApplicationController
  extend T::Sig

  before_action :authenticate_user!

  sig { void }
  def create
    membership = Membership.new(
      user: User.find_by(id: membership_params.user_id),
      organization: Organization.find_by(id: membership_params.organization_id)
    )

    if membership.save
      render json: MembershipSerializer.new(membership).serialize, status: :created, location: membership
    else
      render_errors_for membership
    end
  end

  sig { void }
  def update
    if T.must(current_membership).update(membership_params.as_json)
      render json: MembershipSerializer.new(current_membership).serialize
    else
      render_errors_for T.must(current_membership)
    end
  end

  sig { void }
  def destroy
    T.must(current_membership).destroy
  end

  private

  sig { returns(T.nilable(Membership)) }
  def current_membership
    @current_membership ||= T.let(Membership.find(params[:id]), T.nilable(Membership))
  end

  #
  # MembershipParams
  #

  class MembershipParams < T::Struct
    const :user_id, T.nilable(String)
    const :organization_id, T.nilable(String)
  end

  sig { returns(MembershipParams) }
  def membership_params
    TypedParams[MembershipParams].new.extract!(params.fetch(:membership))
  end
end
