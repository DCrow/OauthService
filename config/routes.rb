OauthService::Engine.routes.draw do
  get "oauth/:provider_name",  to: "oauth#oauth_callback"
  get "logout",  to: "oauth#logout"
end
