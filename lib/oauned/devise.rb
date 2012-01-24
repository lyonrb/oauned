require 'devise'

module Devise

  class << self
    alias :old_include_helpers :include_helpers
    def include_helpers(scope)
      old_include_helpers(scope)

      ActiveSupport.on_load(:action_controller) do
        include Oauned::ControllerMethods
      end
    end
  end
end
