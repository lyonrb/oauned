require 'spec_helper'

describe Oauned::Models::Application do
  let(:application) { Application.create! }
  let(:user) { User.create! }

  describe 'authorize!' do
    it 'should create an authorization object' do
      application.new_record?.should be_false
      lambda do
        application.authorize!(user)
      end.should change(Authorization, :count).by(1)
    end
  end

  describe 'secret' do
    it 'should generate a key' do
      application.consumer_secret.should_not be_nil
    end

    it 'should generate two different keys' do
      application.consumer_secret.should_not eql(Application.create!.consumer_secret)
    end
  end
end
