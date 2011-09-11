module Oauned::Models
  autoload :Application, 'oauned/models/application'
  autoload :Authorization, 'oauned/models/authorization'
  autoload :Connection, 'oauned/models/connection'


  @@models = {}
  def self.[](key)
    @@models[key]
  end

  def self.[]=(key, value)
    @@models[key] = value
  end
end
