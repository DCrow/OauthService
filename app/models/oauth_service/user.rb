module OauthService
  class User < ActiveRecord::Base
    has_many :users_group
  end
end
