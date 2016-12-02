module OauthService
  module Providers
    class Google < Provider
      def get_info(token_result)
        uri = URI.parse(self.info_url)
        headers = { "Authorization" => "Bearer #{token_result["access_token"]}" }

        self.send_request(uri, headers)
      end
    end
  end
end

