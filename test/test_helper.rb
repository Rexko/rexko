# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'capybara/rails'
require 'capybara/minitest'
require 'capybara/minitest/spec'
require 'capybara/apparition'

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
    #
    # Note: You'll currently still have to declare fixtures explicitly in integration tests
    # -- they do not yet inherit this setting
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include Capybara::DSL
    include Capybara::Minitest::Assertions

    Capybara.current_driver = :apparition
    Capybara.javascript_driver = :apparition
    Capybara.server = :puma, { Silent: true }
  end
end

module ActionView
  class TestCase
    setup :controller_with_default_locale

    def controller_with_default_locale
      @controller = TestController.new

      def @controller.default_url_options(_options = {})
        { locale: 'en' }
      end
    end
  end
end

# https://gist.github.com/kerrizor/8bb8f1528c88789c3435
### Bullet (N+1 queries)

if ENV['BULLET']
  Bullet.enable = true

  require 'minitest/unit'

  module MiniTestWithBullet
    def before_setup
      Bullet.start_request
      super if defined?(super)
    end

    def after_teardown
      super if defined?(super)

      if Bullet.warnings.present?
        warnings = Bullet.warnings.map do |_k, warning|
          warning
        end.flatten.map(&:body_with_caller).join("\n-----\n\n")

        flunk(warnings)
      end

      Bullet.end_request
    end
  end

  module ActiveSupport
    class TestCase
      include MiniTestWithBullet
    end
  end
end
