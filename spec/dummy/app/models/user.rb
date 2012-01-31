# encoding: UTF-8
class User < ActiveRecord::Base
  devise :database_authenticatable, :oauthable
  has_many   :authorizations
  has_many   :connections


end
