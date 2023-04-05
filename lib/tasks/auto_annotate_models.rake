# frozen_string_literal: true

if Rails.env.development?
  require 'annotate'

  Annotate.load_tasks
end
