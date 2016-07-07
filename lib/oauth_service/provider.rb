module OauthService 
  class Provider
    attr_reader :name, :downcase_name, :auth_url, :client_id, :client_secret,
      :info_url, :scopes, :token_url
    
    def initialize(name, downcase_name, auth_url, client_id, client_secret,
      info_url, scopes, token_url)
      @name = name
      @downcase_name = downcase_name
      @auth_url = auth_url
      @client_id = client_id
      @client_secret = client_secret
      @info_url = info_url
      @scopes = scopes
      @token_url = token_url
    end
    
    def get_redirect_uri(request_url)
      uri = URI.parse(request_url)
      uri.path = OauthService.redirect_uri + downcase_name
      uri.query = nil
      
      uri.to_s
    end

    def get_auth_uri(request_url)
      uri = URI.parse(auth_url)
      uri.query = URI.encode_www_form(get_auth_params(request_url))

      uri.to_s
    end

    def get_auth_params(request_url)
      {
        "client_id" => client_id,
        "redirect_uri" => get_redirect_uri(request_url),
        "response_type" => "code",
        "scope" => scopes
      }
    end
    
    def get_token_params(options = {})
      {
        "client_id" => client_id,
        "client_secret" => client_secret,
        "redirect_uri" => get_redirect_uri(options[:original_url]),
        "grant_type" => "authorization_code",
        "code" => options[:code]
      }
    end
    
    def get_user_info(redirect_uri, code)
      token_res = self.get_access_token(redirect_uri, code)
      token_res[:error].nil? ? self.get_info(token_res) : token_res
    end

    def get_access_token(redirect_uri, code)
      uri = URI.parse(self.token_url)
      uri.query = URI.encode_www_form(self.get_token_params(original_url: redirect_uri, code: code))

      send_request(uri, nil, "POST")
    end

    def get_info(token_res)
      {}
    end

    protected
      def send_request(uri, headers, method="GET")
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
