module Oauned
  autoload :ControllerMethods, 'oauned/controller_methods'
  autoload :Models, 'oauned/models'
  
  class NoCurrentUserMethod < Exception; end
end

require 'oauned/rails'