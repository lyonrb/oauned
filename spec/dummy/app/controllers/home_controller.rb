class HomeController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!

  def me
    respond_with current_user
  end
end
