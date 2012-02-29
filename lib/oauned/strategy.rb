require 'warden'

module Oauned
  class Strategy < Devise::Strategies::Authenticatable

    def valid?
      !access_token.nil?
    end

    def authenticate!
      resource = mapping.to.find_for_oauth_authentication access_token

      if resource
        success!(resource)
      else
        fail(:invalid)
      end
    end

    def access_token
      match = request.authorization.match(/^OAuth2 (.*)$/) if request.authorization
      match.nil? ? nil : match[1]
    end
  end
end

Warden::Strategies.add(:oauthable, Oauned::Strategy)
