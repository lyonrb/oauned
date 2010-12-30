require 'spec_helper'

describe Oauned::OauthController do
  let(:application) { Application.create!(:redirect_uri => 'http://www.example.net') }
  let(:user) { User.create!}
  
  before :each do
    @controller.current_user = user
  end
  
  describe 'authorize' do
    it 'should require a redirect_uri' do
      post :authorize, :client_id => application.id
      response.status.should eql(400)
    end
    
    it 'should require a client_id' do
      post :authorize
      response.status.should eql(400)
    end
    
    it 'should require a valid redirect_uri' do
      post :authorize, :client_id => application.id, :redirect_uri => 'http://www.example.com'
      response.should be_redirect
    end
    
    it 'should create an authorization' do
      lambda do
        post :authorize, :client_id => application.id, :redirect_uri => application.redirect_uri
      end.should change(Authorization, :count).by(1)
    end
  end
end
