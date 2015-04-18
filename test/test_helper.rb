ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionView::TestCase
  setup :controller_with_default_locale
  
  def controller_with_default_locale
    @controller = TestController.new
    
    def @controller.default_url_options(options = {})
      { locale: 'en' }
    end
  end
end