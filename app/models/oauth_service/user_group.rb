module OauthService
  class UserGroup < ActiveRecord::Base
    has_many :users_group
    has_many :users_url
  end
end
