# typed: strict
# frozen_string_literal: true

module DatabaseCleanerSupport
  extend T::Sig

  sig { void }
  def before_setup
    super
    DatabaseCleaner.start
  end

  sig { void }
  def after_teardown
    DatabaseCleaner.clean
    super
  end
end
