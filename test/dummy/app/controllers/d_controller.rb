class DController < OauthService::AccessController
  def index
    render :json => {:hope => true}
  end
end
