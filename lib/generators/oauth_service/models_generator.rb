require 'rails/generators/base'

module OauthService
  module Generators
    class ModelsGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/models", __FILE__)

      desc "Create inherited Models in your app/models folder."

      def create_models
        MODELS.each do |model|
          template "#{model}.rb", "app/models/#{model}.rb"
        end  
      end
    end
  end
end
