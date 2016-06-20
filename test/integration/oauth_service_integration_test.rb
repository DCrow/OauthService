require "helpers/test_helper"
require "helpers/capybara_helper"

class OauthServiceIntegrationTest < ActionDispatch::IntegrationTest
  include CapybaraHelper

  def test_oauth
    oauth_link = get_oauth_links
    yandex_test(oauth_link[0])
    google_test(oauth_link[1])
  end

  def get_oauth_links
    OauthService::Provider.providers_data.collect do |provider|
       "#{provider.auth_url}?client_id=#{provider.client_id}&"+
      "response_type=code&redirect_uri=#{provider.get_redirect_uri("http://localhost:3000/")}" +
      "&scope=#{provider.scopes}"
    end
  end

  def yandex_test link
    visit link
    fill_in "login", with: ENV["YANDEX_TEST_USER_LOGIN"]
    fill_in "passwd", with: ENV["YANDEX_TEST_USER_PASSWORD"]
    click_button "Войти"
    click_button "Разрешить"

    res = parse_json(page)
   
    assert_equal(page.get_rack_session_key("user_name"), res[:user_name])

    visit "http://localhost:3000/logout"

    rack_session = page.get_rack_session
    assert_equal(rack_session["user_name"], nil)
    assert_equal(rack_session["user_email"], nil)
    assert_equal(rack_session["api_code"], nil)
  end

  def google_test link
    visit link
    fill_in "Email", with: ENV["GOOGLE_TEST_USER_LOGIN"]
    click_on "next"
    fill_in "Passwd", with: ENV["GOOGLE_TEST_USER_PASSWORD"]
    click_on "signIn"
    click_on "submit_approve_access"
    
    res = parse_json(page)
   
    assert_equal(page.get_rack_session_key("user_name"), res[:user_name])

    visit "http://localhost:3000/logout"

    rack_session = page.get_rack_session
    assert_equal(rack_session["user_name"], nil)
    assert_equal(rack_session["user_email"], nil)
    assert_equal(rack_session["api_code"], nil)
  end
end
