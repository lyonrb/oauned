require 'oauned/rails/routing'

module Oauned
  class Engine < ::Rails::Engine
    # Force routes to be loaded if we are doing any eager load.
    config.before_eager_load { |app| app.reload_routes! }
    
    initializer "oauned.controller_helpers" do
      ActiveSupport.on_load(:action_controller) do
        define_method "current_user" do
          raise Oauned::NoCurrentUserMethod
        end
        
        include Oauned::ControllerMethods
      end
    end
  end
end