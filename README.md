# OauthService

Uses Google, Yandex Oauth2 services to authenticate users.

## Before using
All Oauth2 variables should be set in providers_keys variable.
All Oauth2 services should be set up to allow following urls: `.../oauth/<provider_name_downcased>?format=<format_name>`
```ruby
providers_keys = {
    :google => {
      :auth_url => ENV["GOOGLE_AUTH_URL"],
      :client_id => ENV["GOOGLE_CLIENT_ID"],
      :client_secret => ENV["GOOGLE_CLIENT_SECRET"],
      :info_url => ENV["GOOGLE_INFO_URL"],
      :scopes => ENV["GOOGLE_SCOPES"],
      :token_url => ENV["GOOGLE_TOKEN_URL"]
    }
}
```
Format can be changed by changing `:request_format` variable. Default is Json.
Redirect location should be set in `:redirect_uri` varaible.

## How to use
To authenticate send user to a link created by `OauthService::Providers.get_auth_uri`.

After authentication `user_name`, `user_email`, `api_code` are saved in session.
`user_name`, `user_email` variables are returned.

To logout send user to `../logout`
After which `user_name`, `user_email`, `api_code` are removed from session.
