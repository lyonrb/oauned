require 'spec_helper'

describe "controllers" do

  [:current_user].each do |method|
    it "should have the #{method} defined" do
      ApplicationController.new.respond_to?(method).should be_true
    end
  end
end
