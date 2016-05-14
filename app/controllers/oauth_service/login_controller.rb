require "oauth_service"

module OauthService
  class LoginController < AccessController
    def oauth_callback
      user_info = get_user_info(params[:provider_name], request.url, params[:code])

      if user_info
        user = ::User.find_by(name: user_info[:email])
        api_code = generate_api_code
        success = user.blank?

        unless success
          user.update_attributes(:api_code => api_code)
          render :json => {:success => true, :api_code => api_code}, :status => 200
        else
          render :json => {:success => false, :error=> "No such user exists"}, :status => 404
        end
      end
    end

    def logout
      user = ::User.find_by(api_code: api_code)
      success = user.blank?
      unless success
        user.update_attributes(:api_code => nil)
        render :json => {:success => true}, :status => 400
      else
        render :json => {:success => false, :error=> "No such user exists"}, :status => 400
      end
    end

    private
      def generate_api_code
        SecureRandom.uuid
      end

      def get_user_info(provider_name, redirect_uri, code)
      provider = OauthService::Provider::get_provider_by_name(provider_name)
      token_uri = URI.parse(provider.token_url)
      http_token = Net::HTTP.new(token_uri.host, token_uri.port)
      http_token.use_ssl = true if token_uri.scheme == "https"
      
      http_token.start do |http_token_request|
        res = http_token_request.send_request("POST",
          token_uri.request_uri,
          URI.encode_www_form(provider.get_token_params(original_url: redirect_uri, code: code)),
          { 'Content-Type' => "application/x-www-form-urlencoded" }) 
        
        res_body = ActiveSupport::JSON.decode(res.body).symbolize_keys

        if res.code!='200'
          render :json => {
            :success => false,
            :error => res_body[:error],
            :error_description => res_body[:error_description]
          },
            :status => res.code
          return false
        end
        
        info_uri = URI.parse(provider.info_url + "?" +
          URI.encode_www_form(provider.get_info_params(access_token: res_body[:access_token])))
        http_info = Net::HTTP.new(info_uri.host, info_uri.port)
        http_info.use_ssl = true if info_uri.scheme == "https"
        
        http_info.start do |http_info_request|
          res = http_info_request.send_request("GET",
          info_uri.request_uri,
          nil,
          provider.get_info_headers(access_token: res_body[:access_token]))

          res_body = ActiveSupport::JSON.decode(res.body).symbolize_keys
          
          if res.code!='200'
            render :json => {
                :success => false,
                :error => res_body[:error],
                :error_description => res_body[:error_description]
              },
              :status => res.code
            return false
          end
          provider.get_user_info(res_body)
        end
      end
    end
  end
end

