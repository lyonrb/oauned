require 'oauned/rails/routing'

module Oauned
  class Engine < ::Rails::Engine
    # Force routes to be loaded if we are doing any eager load.
    config.before_eager_load { |app| app.reload_routes! }
    
    initializer "oauned.controller_helpers", :after=> :disable_dependency_loading do
      ActiveSupport.on_load(:action_controller) do
        include Oauned::ControllerMethods
        
      end
    end
  end
end