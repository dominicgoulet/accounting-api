# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Core
gem 'jwt'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rack-cors'
gem 'rails', '~> 7.0.4', '>= 7.0.4.3'

# Security
gem 'bcrypt', '~> 3.1.7'

# JSON
gem 'alba'
gem 'oj'

# Sorbet
gem 'sorbet-rails'
gem 'sorbet-runtime'

# Others
gem 'bootsnap', require: false

group :development, :test do
  gem 'annotate'
  gem 'rubocop', require: false
  gem 'sorbet'
  gem 'tapioca'
end

group :test do
  gem 'database_cleaner-active_record'
  gem 'simplecov', require: false
end
