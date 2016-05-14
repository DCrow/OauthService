require 'test_helper'

class OauthServiceProviderTest < ActiveSupport::TestCase
  def test_oauth_redirect
    p OauthService::Access.login('google','http://localhost:3000/' ,'4/bqaYMgiX3QnDkryXeroxGazCmo-PHrCkXZV2s6Ud3u4')
    
  end
end
