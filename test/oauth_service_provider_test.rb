require "helpers/test_helper"
require "helpers/capybara_helper"

class OauthServiceProviderTest < ActiveSupport::TestCase
  include CapybaraHelper
  self.use_transactional_fixtures = false
  self.use_instantiated_fixtures  = false

  def test_login
    page.reset!
    login

    visit "http://localhost:3000/test"
    assert(parse_json(page)[:hello], "Should be true") 
  end

  def test_logout
    page.reset!
    login

    logout

    visit "http://localhost:3000/test"
    assert_equal(parse_json(page)[:error], "Permission denied", "Permission should be denied")
  end

  def login
    visit "http://localhost:3000/login"
    click_link "Авторизация через YANDEX"
    fill_in "login", with: ENV["TEST_USER_LOGIN"]
    fill_in "passwd", with: ENV["TEST_USER_PASSWORD"]
    click_button "Войти"

    res = parse_json(page)
    assert_equal(res[:api_code], User.find_by(name: ENV["TEST_USER_LOGIN"]).api_code, "API_CODE should be same")
    page.driver.add_headers("API_CODE" => res[:api_code])
  end

  def logout
    visit "http://localhost:3000/login/logout"
    
    assert_equal(nil, User.find_by(name: ENV["TEST_USER_LOGIN"]).api_code, "API_CODE should be nil")
    assert(parse_json(page)[:success], "Logout should be true")
  end
end
