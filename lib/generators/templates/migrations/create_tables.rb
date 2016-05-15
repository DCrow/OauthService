class CreateTables < ActiveRecord::Migration
  def self.up

    create_table :users do |t|
      t.string :name, nil: false, index: true
      t.string :api_code
    end

    create_table :urls do |t|
      t.string :url_pattern
      t.string :name
      t.string :http_method
    end

    create_table :user_groups do |t|
      t.string :name, nil: false, index: true
    end

    create_table :users_groups do |t|
      t.integer :user_group_id
      t.integer :user_id
    end

    create_table :users_urls do |t|
      t.integer :user_group_id
      t.integer :url_id
    end

    guest_user = User.create :name => "guest"
    guest_url1 = Url.create :url_pattern => "^/login", :name => "Login page", :http_method => "GET"
    guest_url2 = Url.create :url_pattern => "^/oauth/.*", :name => "AuthCallback page", :http_method => "GET"
    guest_url3 = Url.create :url_pattern => "^/login/logout", :name => "Logout page", :http_method => "GET"
    guest_user_group = UserGroup.create :name => "Guest"
    guest_users_group = UsersGroup.create :user_id => guest_user.id, :user_group_id => guest_user_group.id
    UsersUrl.create  :url_id => guest_url1.id, :user_group_id => guest_user_group.id
    UsersUrl.create  :url_id => guest_url2.id, :user_group_id => guest_user_group.id
    UsersUrl.create  :url_id => guest_url3.id, :user_group_id => guest_user_group.id
  end

  def self.down
    drop_table :users_urls
    drop_table :users_groups
    drop_table :user_groups
    drop_table :users
    drop_table :urls
  end
end
