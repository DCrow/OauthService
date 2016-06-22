require "helpers/test_helper"
require "helpers/capybara_helper"

class OauthServiceIntegrationTest < ActionDispatch::IntegrationTest
  include CapybaraHelper

  OauthService::Provider.providers_data.each do |provider|
    define_method("test_#{provider.downcase_name}".to_sym) do
      visit provider.get_auth_uri("http://localhost:3000/")

      login(provider.downcase_name)

      res = parse_json(page)
    
      assert_equal(page.get_rack_session_key("user_name"), res[:user_name])
      
      visit :logout

      rack_session = page.get_rack_session
      assert_equal(rack_session["user_name"], nil)
      assert_equal(rack_session["user_email"], nil)
      assert_equal(rack_session["api_code"], nil)
    end
  end


  def login provider
    if provider == "yandex"
      fill_in "login", with: ENV["YANDEX_TEST_USER_LOGIN"]
      fill_in "passwd", with: ENV["YANDEX_TEST_USER_PASSWORD"]
      click_button "Войти"
    elsif provider == "google"
      fill_in "Email", with: ENV["GOOGLE_TEST_USER_LOGIN"]
      click_on "next"
      fill_in "Passwd", with: ENV["GOOGLE_TEST_USER_PASSWORD"]
      click_on "signIn"
      click_on "submit_approve_access"
    end 
  end
end
