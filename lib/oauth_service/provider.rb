module OauthService 
  class Provider
    AVAILABLE_PROVIDERS = ['YANDEX', 'GOOGLE', 'MAIL_RU']
    

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
      redirect_uri  = OauthService.redirect_uri

      if redirect_uri[0..3]=="http"
        redirect_uri + downcase_name
      else
        uri = URI.parse(request_url)
        uri.path = redirect_uri + downcase_name
        uri.query = nil
        
        return uri.to_s
      end
    end
    
    def get_token_params(options = {})
      {
        'client_id' => client_id,
        'client_secret' => client_secret,
        'redirect_uri' => get_redirect_uri(options[:original_url]),
        'grant_type' => 'authorization_code',
        'code' => options[:code]
      }
    end
    
    def get_user_info(info)
      info
    end
    
    def get_info_headers(options = {})
      raise "Headers for token request method is undefined"
    end
    
    def get_info_params(options = {})
      raise "Paramaters for information request method is undefined"
    end
    
    def self.providers_data
      @@providers_data ||= AVAILABLE_PROVIDERS.collect do |provider|
        ("OauthService::Provider::#{provider.downcase.camelize}").constantize.new(
          provider,
          provider.downcase,
          ENV["#{provider}_AUTH_URL"],
          ENV["#{provider}_CLIENT_ID"],
          ENV["#{provider}_CLIENT_SECRET"],
          ENV["#{provider}_INFO_URL"],
          ENV["#{provider}_SCOPES"],
          ENV["#{provider}_TOKEN_URL"]
        ) if ENV["#{provider}_AUTH_URL"] &&
          ENV["#{provider}_CLIENT_ID"] &&
          ENV["#{provider}_CLIENT_SECRET"] &&
          ENV["#{provider}_INFO_URL"] &&
          ENV["#{provider}_SCOPES"] &&
          ENV["#{provider}_TOKEN_URL"]
      end.compact
    end
    
    def self.get_provider_by_name(name)
      res = providers_data.select do |provider|
        provider.downcase_name == name.downcase
      end
      
      res ? res.first : nil
    end
  end
end
