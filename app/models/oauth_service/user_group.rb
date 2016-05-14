module OauthService
  class UserGroup < ActiveRecord::Base
    has_many :users_group
  end
end
