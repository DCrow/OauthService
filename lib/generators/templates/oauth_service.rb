OauthService.setup do |config|
  # The relative route where auth service callback is redirected.
  # config.redirect_uri = "/oauth/"

  # Format of page after login/logout
  # config.request_format = "json"

  # Oauth providers to use for Authorization
  # config.available_providers = ['YANDEX', 'GOOGLE']

  # Keys used by Oauth service
  # Write in this format:
  # {
  #   :provider_name_downcased => {
  #     :auth_url => ...,
  #     :client_id => ...,
  #     :client_secret => ...,
  #     :info_url => ...,
  #     :scopes => ...,
  #     :token_url => ...
  #   }
  # }
  # 
  # config.providers_keys = {}
end
