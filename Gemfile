# Edit this Gemfile to bundle your application's dependencies.
# This preamble is the current preamble for Rails 3 apps; edit as needed.

source 'http://rubygems.org'
gem 'bootsnap', require: false
gem 'rails', '7.0.2.4'

gem 'activemodel-serializers-xml'
gem 'globalize', git: 'https://github.com/globalize/globalize'
gem 'globalize-accessors'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3', '~> 1.4.0'

# Use unicorn as the web server
# gem 'unicorn'
gem 'puma'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  # gem 'webrat'
  gem 'bullet'
  gem 'capybara', '~> 3.12'
  # gem 'capybara-webkit'
  gem 'apparition', github: 'twalpole/apparition', ref: 'ca86be4d54af835d531dbcd2b86e7b2c77f85f34'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'listen'
  gem 'minitest', '~> 5.10.0'
  gem 'missing_t', '~> 0.4.1'
  gem 'rails-controller-testing'
  gem 'rubocop', require: false
  gem 'ruby-prof', '~> 0.15.9'
  gem 'test-unit'
end

gem 'multi_json'
# gem 'prototype-rails', github: 'rails/prototype-rails', branch: '4.2' # Not supported in 5.0
gem 'dynamic_form', github: 'joelmoss/dynamic_form', ref: 'refs/pull/21/head'
gem 'jquery-rails'
gem 'sprockets-rails'
gem 'strip_attributes'
gem 'web-console', '~> 2.0', group: :development
gem 'will_paginate', '~> 3.3'
