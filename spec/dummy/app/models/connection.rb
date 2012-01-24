class Connection < ActiveRecord::Base
  include Oauned::Models::Connection

  belongs_to       :user
  belongs_to       :application

end
