require "oauth_service/provider"
require "oauth_service/engine"
require "securerandom"
require "rails"

module OauthService
  MODELS = ['url', 'users_url', 'user', 'user_group', 'users_group']

  # The parent controller all OauthService controllers inherits from.
  # Defaults to "ApplicationController".
  mattr_accessor :parent_controller
  @@parent_controller = "ApplicationController"

  # The relative route where auth service callback is redirected.
  # Defaults to "/oauth/".
  mattr_accessor :redirect_uri
  @@redirect_uri = "/oauth/"

  # Name of the controller which inherits from OauthService::LoginController
  # Defaults to "LoginController".
  mattr_accessor :login_controller
  @@login_controller = "LoginController"

  # Default way to set up OauthService. Run rails generate oauth_service:install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
end
