require 'spec_helper'
require 'cgi'

describe Oauned::OauthController do
  render_views
  
  let(:application) { Application.create!(:redirect_uri => 'http://www.example.net', :name => "My Application") }
  let(:user) { User.create!}
  
  before :each do
    @controller.current_user = user
  end
  
  describe 'index' do    
    it 'should require a redirect_uri' do
      get :index, :client_id => application.id
      response.status.should eql(400)
    end
    
    it 'should require a client_id' do
      get :index
      response.status.should eql(400)
    end
    
    it 'should require a valid redirect_uri' do
      get :index, :client_id => application.id, :redirect_uri => 'http://www.example.com'
      response.should be_redirect
    end
    
    it 'should render the index page' do
      get :index, :client_id => application.id, :redirect_uri => application.redirect_uri
      response.should be_success
    end
    
    it "should display the application's name" do
      get :index, :client_id => application.id, :redirect_uri => application.redirect_uri
      response.body.match(Regexp.new(application.name)).should_not be_nil
    end
    
    it "should skip the confirmation process" do
      application.update_attribute(:no_confirmation, true)
      
      lambda do
        post :index, :client_id => application.id, :redirect_uri => application.redirect_uri
      end.should change(Authorization, :count).by(1)
    end
    
    it "should redirect if the user is not logged in" do
      @controller.current_user = nil
      get :index, :client_id => application.id, :redirect_uri => application.redirect_uri
      response.should be_redirect
    end
    
    it 'should set the current uri in the session' do
      @controller.current_user = nil
      get :index, :client_id => application.id, :redirect_uri => application.redirect_uri
      response.should be_redirect
      session[:redirect_uri].should eql("/?client_id=#{application.id}&redirect_uri=#{CGI.escape(application.redirect_uri)}")
    end
  end
end
