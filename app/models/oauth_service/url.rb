module OauthService
  class Url < ActiveRecord::Base
    has_many :users_url

    def self.by_user(user_id)
      includes(users_url: [user_group: [[users_group: :user]]]).where(:users_groups => {:user_id => user_id}).all
    end
  end
end
