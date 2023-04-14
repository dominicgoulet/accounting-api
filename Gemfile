# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Core
gem 'jwt', '2.7.0'
gem 'pg', '1.4.6'
gem 'puma', '6.2.1'
gem 'rack-cors', '2.0.1'
gem 'rails', '7.0.4.3'

# Security
gem 'bcrypt', '3.1.18'

# JSON
gem 'alba', '2.2.0'
gem 'image_processing', '~> 1.2'
gem 'oj', '3.14.2'

# Sorbet
gem 'sorbet-rails', '0.7.34'
gem 'sorbet-runtime'

# Others
gem 'bootsnap', require: false

group :development, :test do
  gem 'annotate'
  gem 'rubocop', require: false
  gem 'sorbet'
  gem 'tapioca', require: false
end

group :test do
  gem 'database_cleaner-active_record'
  gem 'simplecov', require: false
end
