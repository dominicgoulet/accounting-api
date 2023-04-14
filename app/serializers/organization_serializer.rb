# frozen_string_literal: true

class OrganizationSerializer
  include Alba::Resource

  root_key :organization

  attributes :id, :name, :website, :setup_completed_at
end
