module Oauned::Models

  @@models = {}
  def self.[](key)
    @@models[key]
  end

  def self.[]=(key, value)
    @@models[key] = value
  end
end

require 'oauned/models/application'
require 'oauned/models/authorization'
require 'oauned/models/connection'
require 'oauned/models/oauthable'
