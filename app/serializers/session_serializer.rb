# typed: strict
# frozen_string_literal: true

class SessionSerializer
  extend T::Sig
  include Alba::Resource

  root_key :session

  attributes :id, :email, :first_name, :last_name
end
