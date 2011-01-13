require 'rails/generators/active_record'
require 'generators/oauned/helpers'

module Oauned
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      include Oauned::Generators::Helpers

      desc "Creates the oauned routes and models"
      def add_oauned_routes
        route "scope '/scoped' { oauned_routing }"
      end
      
      def create_models
        [:application, :authorization, :connection].each do |model|
          invoke "active_record:model", [model], :migration => false unless model_exists?(model) && behavior == :invoke
        end
      end
      
      def inject_application_content
        inject_into_class model_path(:application), Application, <<EOS if model_exists?(:authorization)
  include Oauned::Models::Application
  
  has_many   :authorizations
  has_many   :connections
EOS
      end
      
      def inject_authorization_content
        inject_into_class model_path(:authorization), Application, <<EOS if model_exists?(:authorization)
  include Oauned::Models::Authorization
  
  belongs_to       :user
  belongs_to       :application
EOS
      end
      
      def inject_connection_content
        inject_into_class model_path(:connection), Application, <<EOS if model_exists?(:authorization)
  include Oauned::Models::Connection
  
  belongs_to       :user
  belongs_to       :application
EOS
      end
    end
  end
end