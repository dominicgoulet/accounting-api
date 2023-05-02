# typed: strict
# frozen_string_literal: true

class SessionSerializer
  include Alba::Resource

  root_key :session

  attributes :id, :email, :first_name, :last_name
end
