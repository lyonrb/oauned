class Authorization < ActiveRecord::Base
  include Oauned::Models::Authorization

  belongs_to       :user
  belongs_to       :application


end
