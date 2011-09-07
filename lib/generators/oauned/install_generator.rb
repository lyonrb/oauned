require 'rails/generators/active_record'
require 'generators/oauned/helpers'

module Oauned
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Oauned::Generators::Helpers

      argument :application,
        :type => :string,
        :default => "application"
      argument :authorization,
        :type => :string,
        :default => "authorization"
      argument :connection,
        :type => :string,
        :default => "connection"

      desc "Creates the oauned routes and models"
      def add_oauned_routes
        route "scope '/scoped' { oauned_routing }"
      end

      def create_models
        [:application, :authorization, :connection].each do |model_sym|
          model_name = send(model_sym)
          if !model_exists?(model_name)
            Rails::Generators.invoke "active_record:model",
              [model_name],
              :migration => false,
              :destination_root => destination_root
            require File.join(destination_root, model_path(model_name))
          end
        end
      end

      def inject_application_content
        if model_exists?(application)
          inject_into_class model_path(application),
            application.capitalize.constantize,
<<EOS
  include Oauned::Models::Application

  has_many   :authorizations
  has_many   :connections
EOS
        end
      end

      def inject_authorization_content
        if model_exists?(authorization)
          inject_into_class model_path(authorization),
            authorization.capitalize.constantize,
<<EOS
  include Oauned::Models::Authorization

  belongs_to       :user
  belongs_to       :application
EOS
        end
      end

      def inject_connection_content
        if model_exists?(connection)
          inject_into_class model_path(connection),
            connection.capitalize.constantize,
 <<EOS
  include Oauned::Models::Connection

  belongs_to       :user
  belongs_to       :application
EOS
        end
      end
    end
  end
end
