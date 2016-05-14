require 'rails/generators/base'

module OauthService
  module Generators
    class ControllersGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/controllers", __FILE__)

      desc "Create inherited LoginController in your app/controllers folder."

      def create_controllers
        template "login_controller.rb", "app/controllers/login_controller.rb"
      end
    end
  end
end
