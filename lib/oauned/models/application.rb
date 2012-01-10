module Oauned::Models::Application
  def self.included(klass)
    Oauned::Models['application'] = klass

    klass.class_eval do
      before_validation    :set_default,
        :on => :create

      def authorize!(user)
        Oauned::Models['authorization'].create!(:user_id => user.id, :application_id => id)
      end

      private
      def set_default
        self.consumer_secret = SecureRandom.hex(40)
      end
    end
  end
end
