module Oauned::Models::Application
  def self.included(klass)
    klass.class_eval do
      before_create    :set_default

      def authorize!(user)
        Authorization.create!(:user_id => user.id, :application_id => id)
      end

      private
      def set_default
        self.consumer_secret = SecureRandom.hex(40)
      end
    end
  end
end