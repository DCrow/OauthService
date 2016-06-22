OauthService::Engine.routes.draw do
  get "oauth/:provider_name",  to: "oauth#oauth_callback"
  get "logout",  to: "oauth#logout"
  
  resources :logout, path: "logout"
  resources :oauth,  path: "oauth/:provider_name"
end
