require 'spec_helper'

class OauthFakeControllerMethods
  attr_accessor   :action_name

  def current_user
    nil
  end
  include Oauned::ControllerMethods

  def params
    @params ||= {
      :access_token => 'abcdefghij'
    }
  end
  def request
    @request ||= Class.new do
      def self.env
        @env ||= {
          'warden' => OpenStruct.new
        }
      end
    end
  end
end

describe Oauned::ControllerMethods do
  before :each do
    OauthFakeControllerMethods.oauth_options = nil

    @controller = OauthFakeControllerMethods.new
    @controller.action_name = 'index'
  end

  let(:token) { Connection.create! }

  describe 'deny_oauth' do
    it 'should have the method' do
      OauthFakeControllerMethods.respond_to?(:deny_oauth).should eql(true)
    end

    it 'should not accept both accept and except' do
      lambda do
        OauthFakeControllerMethods.deny_oauth :only => :index, :except => :show
      end.should raise_error
    end

    it 'should add :only options' do
      OauthFakeControllerMethods.deny_oauth :only => :index
      OauthFakeControllerMethods.oauth_options.should eql({:only => [:index].map(&:to_s).to_set})
    end

    it 'should add :except options' do
      OauthFakeControllerMethods.deny_oauth :except => :index
      OauthFakeControllerMethods.oauth_options.should eql({:except => [:index].map(&:to_s).to_set})
    end

    it 'should initialize the options' do
      OauthFakeControllerMethods.deny_oauth
      OauthFakeControllerMethods.oauth_options.should eql({})
    end
  end

  describe 'oauth_user' do
    it 'should have the method' do
      @controller.respond_to?(:oauth_user).should eql(true)
    end

    it 'should return the user' do
      token.update_attribute(:access_token, 'abcdefghij')
      @controller.send(:oauth_user).should eql(token.user)
    end

    it 'should not return if not allowed' do
      token.update_attribute(:access_token, 'abcdefghij')
      OauthFakeControllerMethods.deny_oauth
      @controller.send(:current_user).should be_nil
    end
  end

  describe 'current_user' do
    it 'should return the normal user' do
      @controller.expects(:normal_user).returns(token.user)
      @controller.send(:current_user).should eql(token.user)
    end

    it 'should return the oauth user' do
      token.update_attribute(:access_token, 'abcdefghij')
      @controller.send(:current_user).should eql(token.user)
    end

    it 'should not return any user' do
      @controller.send(:current_user).should be_nil
    end
  end

  describe 'user_from_oauth' do
    it 'should not find any user' do
      OauthFakeControllerMethods.new.send(:user_from_oauth).should be_nil
    end

    it 'should return the user' do
      token.update_attribute(:access_token, 'abcdefghij')
      OauthFakeControllerMethods.new.send(:user_from_oauth).should eql(token.user)
    end
  end

  describe 'oauth_allowed?' do
    it 'should allow oauth by default' do
      @controller.send(:oauth_allowed?).should eql(true)
    end

    it 'should allow oauth' do
      OauthFakeControllerMethods.deny_oauth :except => :index
      @controller.send(:oauth_allowed?).should eql(true)
    end

    it 'should deny oauth' do
      OauthFakeControllerMethods.deny_oauth
      @controller.send(:oauth_allowed?).should eql(false)
    end

    it 'should allow oauth even if an other action is denied' do
      OauthFakeControllerMethods.deny_oauth :only => :index
      @controller.action_name = 'show'
      @controller.send(:oauth_allowed?).should eql(true)
    end
  end
end
