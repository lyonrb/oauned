require 'devise'

module Oauned
  module Models
    module Oauthable
      extend ActiveSupport::Concern

      module ClassMethods

        def find_for_oauth_authentication(access_token)
          token = Oauned::Models['connection'].where(['access_token LIKE ?', access_token]).first
          token.user if (token && !token.expired?)
        end
      end
    end
  end
end

Devise::Models::Oauthable = Oauned::Models::Oauthable
