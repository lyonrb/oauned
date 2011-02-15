require 'spec_helper'

describe Oauned::OauthController do
  let(:application) { Application.create!(:redirect_uri => 'http://www.example.net') }
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
    
    it "should redirect if the user is not logged in" do
      @controller.current_user = nil
      get :index, :client_id => application.id, :redirect_uri => application.redirect_uri
      response.should be_redirect
    end
  end
end
