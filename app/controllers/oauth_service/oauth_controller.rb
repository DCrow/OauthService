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
        render format => {:success => false, :error => user_info[:error]}, :status => user_info[:status]
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
        uri = URI.parse(provider.token_url)
        uri.query = URI.encode_www_form(provider.get_token_params(original_url: redirect_uri, code: code))
        headers = { "Content-Type" => "application/x-www-form-urlencoded" }

        send_request("POST", uri, headers)
      end

      def get_info(provider, access_token)
        uri = URI.parse(provider.info_url)
        uri.query = URI.encode_www_form(provider.get_info_params(access_token: access_token))
        headers = provider.get_info_headers(access_token: access_token)

        send_request("GET", uri, headers)
      end


      def send_request(method, uri, headers)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true if uri.scheme == "https"
          
        http.start do |http_info_request|
          res = http_info_request.send_request(
            method,
            uri.request_uri,
            uri.query == "" ? nil : uri.query,
            headers)

          res_body = res.body != "" ? ActiveSupport::JSON.decode(res.body) : {}

          if res.code!="200"
            { 
              :error => res_body["error"],
              :status => res.code
            }
          else
            res_body
          end
        end
      end
  end
end

