module Oauned::Models::Authorization
  def self.included(klass)
    Oauned::Models['authorization'] = klass

    klass.class_eval do
      before_validation    :set_default,
        :on => :create

      def expires_in
        (expires_at - Time.now).to_i
      end
      def expired?
        expires_in <= 0
      end

      def tokenize!
        self.destroy
        Oauned::Models['connection'].create!(:user_id => user_id, :application_id => application_id)
      end

      private
      def set_default
        self.code = SecureRandom.hex(20)
        self.expires_at = 1.hour.from_now
      end
    end
  end
end
