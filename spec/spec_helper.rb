$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "lib")

require 'spec'
require 'greed_console'

Spec::Runner.configure do |config|
  config.mock_with :flexmock
end