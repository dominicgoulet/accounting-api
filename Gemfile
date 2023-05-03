# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Core
gem 'jwt', '2.7.0'
gem 'pg', '1.5.3'
gem 'puma', '6.2.2'
gem 'rack-cors', '2.0.1'
gem 'rails', '7.0.4.3'

# Security
gem 'bcrypt', '3.1.18'
gem 'omniauth', '2.1.1'
gem 'omniauth-facebook', '9.0.0'
gem 'omniauth-google-oauth2', '1.1.1'
gem 'repost', '0.4.1'

# JSON
gem 'alba', '2.3.0'
gem 'oj', '3.14.3'

# Sorbet
gem 'sorbet-rails', '0.7.34'
gem 'sorbet-runtime', '0.5.10801'

# Others
gem 'bootsnap', '1.16.0', require: false

group :development, :test do
  gem 'annotate'
  gem 'guard'
  gem 'guard-minitest'
  gem 'rubocop', require: false
  gem 'sorbet'
  gem 'tapioca', require: false
end

group :test do
  gem 'database_cleaner-active_record'
  gem 'simplecov', require: false
end
