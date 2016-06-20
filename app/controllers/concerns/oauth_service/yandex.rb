module OauthService
  class Yandex < Provider
    def get_user_info(info)
      {
        "email" => info["default_email"],
        "id" => info["id"],
        "name" => info["display_name"]
      }
    end
    
    def get_info_headers(options = {})
      { "Authorization" => "OAuth #{options[:access_token]}" }
    end
    
    def get_info_params(options = {})
      {}
    end
  end
end 
