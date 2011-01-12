require 'oauned/rails/routing'

module Oauned
  class Engine < ::Rails::Engine
    # Force routes to be loaded if we are doing any eager load.
    config.before_eager_load { |app| app.reload_routes! }
    
  end
end