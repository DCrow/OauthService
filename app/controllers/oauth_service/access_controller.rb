module OauthService
  class AccessController < OauthService.parent_controller.constantize
    before_filter :check_access
    
    def get_user_id
      if (api_code = request.headers["HTTP_API_CODE"]) && api_code!=""
        user = ::User.find_by(api_code: api_code)
      else
        user = ::User.find_by(name: "guest")
      end
      user.id 
    end
    
    def check_access
      check_status = false
      path = request.path
      http_method = request.method.to_s
      user_urls = ::Url.by_user get_user_id
      
      check_status = user_urls.any? do |user_url|
        path[Regexp.new(user_url.url_pattern)]==path &&
        (user_url.http_method.nil? || http_method==user_url.http_method)
      end

      unless check_status
        if request.headers["HTTP_API_CODE"]
          render :json => {:success => false, :error => "Not authorized"}, :status => 401      
        else
          render :json => {:success => false, :error => "Permission denied"}, :status => 403
        end
      end
    end
  end
end
