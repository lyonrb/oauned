class ApplicationController < ActionController::Base
  attr_accessor :current_user
  protect_from_forgery
  
end
