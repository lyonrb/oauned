require 'spec_helper'

describe "routing" do
  
  describe "without a scope" do
    
    it "should create the root url" do
      { :get => "/" }.should route_to( :controller => "oauned/oauth", :action => "index" )
    end
    
    it "should create the authorize url" do
      { :post => "/" }.should route_to( :controller => "oauned/oauth", :action => "authorize" )
    end
    
    it "should create the token url" do
      { :post => "/token" }.should route_to( :controller => "oauned/oauth", :action => "token" )
    end
  end
  
  describe "with a scope" do
    
    it "should create the root url" do
      { :get => "/scoped" }.should route_to( :controller => "oauned/oauth", :action => "index" )
    end
    
    it "should create the authorize url" do
      { :post => "/scoped" }.should route_to( :controller => "oauned/oauth", :action => "authorize" )
    end
    
    it "should create the token url" do
      { :post => "/scoped/token" }.should route_to( :controller => "oauned/oauth", :action => "token" )
    end
  end
end