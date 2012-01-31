module Oauned
  module ControllerMethods
    def self.included(klass)
      klass.class_eval do
        cattr_accessor :oauth_options, :oauth_options_proc

        protected
        def self.deny_oauth(options = {}, &block)
          raise 'options cannot contain both :only and :except' if options[:only] && options[:except]

          [:only, :except].each do |k|
            if values = options[k]
              options[k] = Array(values).map(&:to_s).to_set
            end
          end
          self.oauth_options = options
          self.oauth_options_proc = block
        end

        def oauth_allowed?
          return true if (oauth_options_proc && !oauth_options_proc.call(self)) || oauth_options.nil?
          return false if oauth_options.empty?
          return true if oauth_options[:only] && !oauth_options[:only].include?(action_name)
          return true if oauth_options[:except] && oauth_options[:except].include?(action_name)
          false
        end
      end
    end
  end
end
