# typed: strict
# frozen_string_literal: true

class ApplicationRecordErrorSerializer
  extend T::Sig
  include Alba::Resource

  root_key :errors
end
