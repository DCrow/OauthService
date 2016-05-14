OauthService.setup do |config|
  # The parent controller all OauthService controllers inherits from.
  # config.parent_controller = "ApplicationController"

  # The controller name where auth callback is redirected.
  # Has to extend OauthService::LoginController.
  # Change if default login controller is not LoginController.
  # config.login_controller = "LoginController"

  # The relative route where auth service callback is redirected.
  # config.redirect_uri = "/oauth/"
end
