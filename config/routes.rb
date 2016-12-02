OauthService::Engine.routes.draw do
  get "callback/:provider_name",  to: "oauth#callback"
  get "logout",  to: "oauth#logout"
  get "login", to: "oauth#login"
  get "info", to: "oauth#info"
end
