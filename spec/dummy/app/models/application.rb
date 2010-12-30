class Application < ActiveRecord::Base
  include Oauned::Models::Application
  
  has_many   :authorizations
  has_many   :connections
  
  
end
