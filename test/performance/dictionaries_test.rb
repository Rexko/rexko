require 'test_helper'
require 'rails/performance_test_help'

class DictionariesTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { :runs => 5, :metrics => [:wall_time, :memory]
  #                          :output => 'tmp/performance', :formats => [:flat] }

  def test_dictionaries
    Dictionary.find_each {|dict|
      get url_for(dict)
    }
  end
end
