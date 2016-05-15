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

    
  end

  def self.down
    drop_table :users_urls
    drop_table :users_groups
    drop_table :user_groups
    drop_table :users
    drop_table :urls
  end
end
