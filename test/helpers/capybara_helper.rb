require "capybara/rails"
require "capybara/poltergeist"
require "database_cleaner"

module CapybaraHelper
  include Capybara::DSL

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, { timeout: 180, js_errors: true })
  end

  def create_test_data
    guest_user = User.create :name => "guest"
    guest_url1 = Url.create :url_pattern => "^/login", :name => "Login page", :http_method => "GET"
    guest_url2 = Url.create :url_pattern => "^/oauth/.*", :name => "AuthCallback page", :http_method => "GET"
    guest_url3 = Url.create :url_pattern => "^/login/logout", :name => "Logout page", :http_method => "GET"
    guest_user_group = UserGroup.create :name => "Guest"
    UsersGroup.create :user_id => guest_user.id, :user_group_id => guest_user_group.id
    UsersUrl.create  :url_id => guest_url1.id, :user_group_id => guest_user_group.id
    UsersUrl.create  :url_id => guest_url2.id, :user_group_id => guest_user_group.id
    UsersUrl.create  :url_id => guest_url3.id, :user_group_id => guest_user_group.id
    
    test_user = User.create name: ENV["TEST_USER_LOGIN"]
    test_user_group = UserGroup.create :name => "Test"
    UsersGroup.create :user_id => test_user.id, :user_group_id => test_user_group.id
    UsersGroup.create :user_id => test_user.id, :user_group_id => guest_user_group.id
    test_url = Url.create :url_pattern => "^/test", :name => "Test page", :http_method => "GET"
    UsersUrl.create :url_id =>  test_url.id, :user_group_id => test_user_group.id
  end
  
  def setup
   DatabaseCleaner.strategy = nil
    
    while (defined? @@suite_setup_completed) && !@@suite_setup_completed do
      sleep(10)
    end
    before_suite until (defined? @@suite_setup_completed) && @@suite_setup_completed
  end
  
  def setup_driver
    Capybara.configure do |config|
      config.current_driver = :poltergeist
      config.run_server = true
      config.app_host = "http://localhost:3000"
      config.server_port = 3000
      config.default_max_wait_time = 180
    end
  end
  
  def before_suite
    @@suite_setup_completed = false

    DatabaseCleaner.clean
    
    setup_driver
    
    create_test_data
    
    @@suite_setup_completed = true
  end

  def parse_json(page)
    ActiveSupport::JSON.decode(page.first("pre").text).symbolize_keys
  end
end
