require 'rails/generators/migration'

module OauthService
  module Generators
    class MigrationsGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path("../../templates/migrations", __FILE__)

      desc "Create table migration in your db/migrate folder."

      def create_migrations
        migration_template "create_tables.rb", "db/migrate/create_tables.rb"
      end

      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
    end
  end
end
