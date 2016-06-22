module OauthService
  module Providers
    class Google < Provider
      def get_info_headers(options = {})
        { "Authorization" => "Bearer #{options[:access_token]}" }
      end

      def get_info_params(options = {})
        {}
      end
    end
  end
end
    
