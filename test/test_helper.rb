# frozen_string_literal: true

require 'simplecov'
SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'database_cleaner-active_record'
require 'database_cleaner_support'
require 'session_helper'

DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :transaction

module ActiveSupport
  class TestCase
    include DatabaseCleanerSupport

    # parallelize(workers: :number_of_processors)
    fixtures :all
  end
end

module ActionDispatch
  class IntegrationTest
    include DatabaseCleanerSupport
  end
end
