require 'warden'

module Oauned
  class Strategy < Devise::Strategies::Authenticatable

    def valid?
      params.has_key?(:access_token)
    end

    def authenticate!
      resource = mapping.to.find_for_oauth_authentication(params[:access_token])

      if resource
        success!(resource)
      else
        fail(:invalid)
      end
    end
  end
end

Warden::Strategies.add(:oauthable, Oauned::Strategy)
