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
      t.integer :users_group_id
      t.integer :url_id
    end

    User.create :name => "guest", :id => 1
    Url.create :url_pattern => "^/login", :name => "Login page", :http_method => "GET", :id => 1
    Url.create :url_pattern => "^/oauth/.*", :name => "AuthCallback page", :http_method => "GET", :id => 2
    UserGroup.create :id => 1, :name => "Guest"
    UsersGroup.create :id => 1, :user_id => 1, :user_group_id => 1
    UsersUrl.create :id => 1, :url_id => 1, :users_group_id => 1
    UsersUrl.create :id => 2, :url_id => 2, :users_group_id => 1
  end

  def self.down
    drop_table :users_urls
    drop_table :users_groups
    drop_table :user_groups
    drop_table :users
    drop_table :urls
  end
end
