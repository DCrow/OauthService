module OauthService
  class UsersUrl < ActiveRecord::Base
    belongs_to :url
    belongs_to :users_group
  end
end
