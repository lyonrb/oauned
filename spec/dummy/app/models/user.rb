# encoding: UTF-8
class User < ActiveRecord::Base
  has_many   :authorizations
  has_many   :connections
  
  
end
