module OauthService
  class UsersUrl < ActiveRecord::Base
    belongs_to :url
    belongs_to :user_group
  end
end
