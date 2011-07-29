require 'spec_helper'

describe Oauned::OauthController do
  let(:application) { Application.create!(:redirect_uri => 'http://www.example.net') }
  let(:user) { User.create!}
  let(:authorization) { Authorization.create!(:user_id => user.id, :application_id => application.id)}
  let(:token) { Connection.create!(:application_id => application.id, :user_id => user.id, :refresh_token => 'testing_' + rand.to_s)}

  before :each do
    @controller.current_user = user
  end

  describe 'token' do
    #it 'should have a grant-type' do
    #  post :token
    #  response.status.should eql(400)
    #  response.body.should eql({
    #    :error => 'unsupported-grant-type',
    #    :error_description => "Grant type  is not supported!"}.to_json)
    #end

    #it 'should have a valid grant-type' do
    #  post :token, :grant_type => 'testing'
    #  response.status.should eql(400)
    #  response.body.should eql({
    #    :error => 'unsupported-grant-type',
    #    :error_description => "Grant type testing is not supported!"}.to_json)
    #end

    it 'should have a client_id' do
      lambda do
        post :token,
          :grant_type => 'authorization-code'
      end.should raise_error ActiveRecord::RecordNotFound
    end

    it 'should have a client_secret' do
      post :token,
        :grant_type => 'authorization-code',
        :client_id => application.id
      response.status.should eql(400)
      response.body.should eql({:error => 'invalid-client-credentials', :error_description => 'Invalid client credentials!'}.to_json)
    end
    it 'should have a valid client_secret' do
      post :token,
        :grant_type => 'authorization-code',
        :client_id => application.id,
        :client_secret => 'testing'
      response.status.should eql(400)
      response.body.should eql({:error => 'invalid-client-credentials', :error_description => 'Invalid client credentials!'}.to_json)
    end

    it 'should have a redirect_uri' do
      post :token,
        :grant_type => 'authorization-code',
        :client_id => application.id,
        :client_secret => application.consumer_secret
      response.status.should eql(400)
      response.body.should eql({:error => 'invalid-grant', :error_description => 'Redirect uri mismatch!'}.to_json)
    end

    it 'should have a valid redirect_uri' do
      post :token,
        :grant_type => 'authorization-code',
        :client_id => application.id,
        :client_secret => application.consumer_secret,
        :redirect_uri => 'http://www.example.com'
      response.status.should eql(400)
      response.body.should eql({:error => 'invalid-grant', :error_description => 'Redirect uri mismatch!'}.to_json)
    end

    describe 'authorization-code' do
      it 'should have a non expired authorization' do
        authorization.update_attribute(:expires_at, 1.second.ago)
        post :token,
          :grant_type => 'authorization-code',
          :client_id => application.id,
          :client_secret => application.consumer_secret,
          :redirect_uri => application.redirect_uri,
          :code => authorization.code
        response.status.should eql(400)
        response.body.should eql({:error => 'invalid-grant', :error_description => "Authorization expired or invalid!"}.to_json)
      end

      it 'should have an authorization for the application' do
        authorization.update_attribute(:application_id, 0)
        post :token,
          :grant_type => 'authorization-code',
          :client_id => application.id,
          :client_secret => application.consumer_secret,
          :redirect_uri => application.redirect_uri,
          :code => authorization.code
        response.status.should eql(400)
        response.body.should eql({:error => 'invalid-grant', :error_description => "Authorization expired or invalid!"}.to_json)
      end

      it 'should create the token' do
        lambda do
          post :token,
            :grant_type => 'authorization-code',
            :client_id => application.id,
            :client_secret => application.consumer_secret,
            :redirect_uri => application.redirect_uri,
            :code => authorization.code
        end.should change(Connection, :count).by(1)
        response.should be_success
      end
    end

    describe 'refresh' do
      it 'should have a token for the application' do
        token.update_attribute(:application_id, 0)
        post :token,
          :grant_type => 'refresh-token',
          :client_id => application.id,
          :client_secret => application.consumer_secret,
          :redirect_uri => application.redirect_uri,
          :refresh_token => token.refresh_token
        response.status.should eql(400)
        response.body.should eql({:error => 'invalid-grant', :error_description => 'Refresh token is invalid!'}.to_json)
      end

      it 'should destroy the current token' do
        post :token,
          :grant_type => 'refresh-token',
          :client_id => application.id,
          :client_secret => application.consumer_secret,
          :redirect_uri => application.redirect_uri,
          :refresh_token => token.refresh_token
        Connection.find_by_id(token.id).should be_nil
      end

      it 'should create a new token' do
        lambda do
          post :token,
            :grant_type => 'refresh-token',
            :client_id => application.id,
            :client_secret => application.consumer_secret,
            :redirect_uri => application.redirect_uri,
            :refresh_token => token.refresh_token
          response.should be_success
        end.should change(Connection.all, :count).by(0)
      end
    end
  end
end
