module Oauned::Models::Connection
  def self.included(klass)
    Oauned::Models['connection'] = klass

    klass.class_eval do
      before_validation    :set_default,
        :on => :create

      def expires_in
        (expires_at - Time.now).to_i
      end
      def expired?
        expires_in <= 0
      end

      def refresh
        self.destroy
        self.class.create!(:user_id => user.id, :application_id => application.id)
      end

      private
      def set_default
        self.access_token = SecureRandom.hex(20)
        self.refresh_token = SecureRandom.hex(20)
        self.expires_at = 1.hour.from_now
      end
    end
  end
end
