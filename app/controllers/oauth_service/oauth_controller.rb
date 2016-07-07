module OauthService
  class OauthController < ApplicationController
    def oauth_callback
      provider = OauthService::Providers.by_name(params[:provider_name])
      user_info = provider.get_user_info(request.url, params[:code])
      format = (params[:format] || OauthService.request_format).to_sym

      if user_info[:error].nil?
        session[:api] = generate_api_code
        session[:user_name] = user_info["name"]
        session[:user_email] = user_info["email"]
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
      session[:api] = nil
      session[:user_name] = nil
      session[:user_email] = nil
      format = (params[:format] || OauthService.request_format).to_sym
      render format => {:success => true}, :status => 200
    end

    protected
      def generate_api_code
        SecureRandom.uuid
      end
  end
end

