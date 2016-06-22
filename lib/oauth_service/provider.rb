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
    
    def get_user_info(info)
      info
    end
    
    def get_info_headers(options = {})
      {}
    end
    
    def get_info_params(options = {})
      {}
    end
    
    def self.providers_data
      @@providers_data ||= OauthService.available_providers.collect do |provider|
        keys = OauthService.providers_keys[provider.downcase.to_sym]
        ("OauthService::Providers::#{provider.downcase.camelize}").constantize.new(
          provider,
          provider.downcase,
          keys[:auth_url],
          keys[:client_id],
          keys[:client_secret],
          keys[:info_url],
          keys[:scopes],
          keys[:token_url]
        ) if !keys.nil? &&
          keys[:auth_url] &&
          keys[:client_id] &&
          keys[:client_secret] &&
          keys[:info_url] &&
          keys[:scopes] &&
          keys[:token_url]
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
