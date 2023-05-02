# typed: strict
# frozen_string_literal: true

# == Schema Information
#
# Table name: organizations
#
#  id                 :uuid             not null, primary key
#  name               :string
#  website            :string
#  setup_completed_at :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class OrganizationSerializer
  include Alba::Resource

  root_key :organization

  attributes :id, :name, :website, :setup_completed_at
end
