module OauthService
  class MailRu < Provider  
    def initialize(name, downcase_name, auth_url, client_id, client_secret,
      info_url, scopes, token_url)
      super(name, downcase_name, auth_url, client_id, client_secret,
      info_url, scopes, token_url)
      @scopes = nil
    end
    
    def get_user_info(info)
      info.first
    end
    
    def get_info_headers(options = {})
      nil
    end
    
    def get_info_params(options = {})
      query_params = {
        'app_id' => client_id,
        'method' => 'users.getInfo',
        'secure' => 1,
        'session_key' => options[:access_token]
      }
      query_params['sig'] = Digest::MD5.hexdigest(query_params.collect { |v| v.join('=') }.join + client_secret)
      query_params
    end
  end
end
