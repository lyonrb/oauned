require 'rails/generators/active_record'
require 'generators/oauned/helpers'

module Oauned
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      include Oauned::Generators::Helpers
      source_root File.expand_path("../templates", __FILE__)

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

      def copy_migration
        [:application, :authorization, :connection].each do |model_sym|
          model_name = send(model_sym)
          @table_name = model_name.pluralize
          if (behavior == :invoke && model_exists?(model_name)) || (behavior == :revoke && migration_exists?(model_name))
            migration_template "migration_existing.rb",
              "db/migrate/add_oauned_to_#{model_name}"
          else
            migration_template "migration.rb",
              "db/migrate/oauned_create_#{model_name}"
          end
        end
      end

      def create_models
        [:application, :authorization, :connection].each do |model_sym|
          model_name = send(model_sym)
          if !model_exists?(model_name) && behavior == :invoke
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

      private
      #
      # We can't use an argument, but must rely on the name attribute
      # Because ActiveRecord::Generators::Base extends from NamedBase
      #
      def application
        @application ||= name || "application"
      end

    end
  end
end
