module OauthService
  class OauthController < ApplicationController
    def oauth_callback
      user_info = get_user_info(params[:provider_name], request.url, params[:code])
      format = (params[:format] || OauthService.request_format).to_sym

      if user_info[:error].nil?
        session[:api_code] = generate_api_code
        render format => {
            :success => true,
            :user_name => session[:user_name],
            :user_email => session[:user_email]
          },
          :status => 200
      else
        render format => user_info[:error], :status => user_info[:status]
      end
    end

    def logout
      session[:api_code] = nil
      session[:user_name] = nil
      session[:user_email] = nil
      format = (params[:format] || OauthService.request_format).to_sym
      render format => {:success => true}, :status => 200
    end

    protected
      def generate_api_code
        SecureRandom.uuid
      end

    private
      def get_user_info(provider_name, redirect_uri, code)
        provider = OauthService::Provider.get_provider_by_name(provider_name)
        res = get_access_token(provider, redirect_uri, code)

        if res[:error].nil?
          res = get_info(provider, res["access_token"])
          if res[:error].nil?
            user_info = provider.get_user_info(res)
            session[:user_name] = user_info["name"]
            session[:user_email] = user_info["email"]
          end
        end
        res
      end

      def get_access_token(provider, redirect_uri, code)
        token_uri = URI.parse(provider.token_url)
        http_token = Net::HTTP.new(token_uri.host, token_uri.port)
        http_token.use_ssl = true if token_uri.scheme == "https"
        
        http_token.start do |http_token_request|
          res = http_token_request.send_request(
            "POST",
            token_uri.request_uri,
            URI.encode_www_form(provider.get_token_params(original_url: redirect_uri, code: code)),
            { "Content-Type" => "application/x-www-form-urlencoded" }) 
          
          res_body = res.body != "" ? ActiveSupport::JSON.decode(res.body) : {}

          if res.code!="200"
            {
              :error => {
                :success => false,
                :error => res_body["error"]
              },
              :status => res.code
            }
          else
            res_body
          end
        end
      end

      def get_info(provider, access_token)
        info_uri = URI.parse(provider.info_url + "?" +
            URI.encode_www_form(provider.get_info_params(access_token: access_token)))
        http_info = Net::HTTP.new(info_uri.host, info_uri.port)
        http_info.use_ssl = true if info_uri.scheme == "https"
          
        http_info.start do |http_info_request|
          res = http_info_request.send_request(
            "GET",
            info_uri.request_uri,
            nil,
            provider.get_info_headers(access_token: access_token))

          res_body = res.body != "" ? ActiveSupport::JSON.decode(res.body) : {}

          if res.code!="200"
            {
              :error => {
                  :success => false,
                  :error => res_body["error"]
                },
              :status => res.code
            }
          else
            res_body
          end
        end
      end
  end
end

