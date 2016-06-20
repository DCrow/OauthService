require "capybara/rails"
require "rack_session_access/capybara"

module CapybaraHelper
  include Capybara::DSL
  
  def setup
    Capybara.configure do |config|
      config.current_driver = :selenium
      config.run_server = true
      config.app_host = "http://localhost:3000"
      config.server_port = 3000
      config.default_max_wait_time = 180
    end
  end

  def parse_json(page)
    ActiveSupport::JSON.decode(page.first("pre").text).symbolize_keys
  end
end
