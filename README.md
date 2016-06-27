= OauthService

Authentication Service

Uses Google, Yandex Oauth2 services to authenticate users.

== Before using
All Oauth2 variables should be set in providers_keys variable.
All Oauth2 services should be set up to allow following urls: ".../oauth/<provider_name_downcased>?format=<format_name>"

Format can be changed by changing request_format variable. Default is Json.
Redirect location should be set in redirect_uri varaible.

== How to use
To authenticate send user to a link created by OauthService::Providers.get_auth_uri method.

After authentication user_name, user_email, api_code are saved in session.
user_name, user_email variables are returned.

To logout send user to ../logout
After which user_name, user_email, api_code are removed from session.
