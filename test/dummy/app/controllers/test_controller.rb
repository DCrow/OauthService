class TestController < OauthService::AccessController
  def index
    render :json => {:hello => true}
  end
end
