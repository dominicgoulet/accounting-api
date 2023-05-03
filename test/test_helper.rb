# typed: ignore
# frozen_string_literal: true

unless ENV['NO_COVERAGE']
  require 'simplecov'
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
  SimpleCov.start 'rails'
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'database_cleaner-active_record'
require 'database_cleaner_support'
require 'session_helper'
require 'json_helper'

DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :transaction

module ActiveSupport
  class TestCase
    extend T::Sig
    include DatabaseCleanerSupport

    fixtures :all
  end
end

module ActionDispatch
  class IntegrationTest
    extend T::Sig
    include DatabaseCleanerSupport

    fixtures :all
  end
end
