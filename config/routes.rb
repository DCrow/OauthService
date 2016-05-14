require "oauth_service"

Rails.application.routes.draw do
  get "#{OauthService.redirect_uri}/:provider_name",  to: "#{OauthService.login_controller[0..-11].downcase}#oauth_callback"
  get "#{OauthService.redirect_uri}/logout",  to: "#{OauthService.login_controller[0..-11].downcase}#logout"
end
