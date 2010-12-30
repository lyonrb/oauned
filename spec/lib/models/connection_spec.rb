require 'spec_helper'

describe Oauned::Models::Connection do
  let(:application) { Application.create! }
  let(:user) { User.create! }
  let(:connection) { Connection.create!(:application => application, :user => user) }
  
  it 'should create the object' do
    lambda do
      Connection.create!.new_record?.should be_false
    end.should change(Connection, :count).by(1)
  end
  
  describe 'expires_in' do
    (0..10).each do |i|
      it "should return #{i}" do
        Timecop.freeze(Time.now) do
          connection.update_attribute(:expires_at, i.seconds.from_now)
          connection.expires_in.should eql(i)
        end
      end
    end
  end
  
  describe 'expired?' do
    it 'should be expired' do
      connection.update_attribute(:expires_at, 1.seconds.from_now)
      connection.expired?.should eql(true)
    end
    
    it 'should not be expired' do
      connection.expired?.should eql(false)
    end
  end
  
  describe 'refresh' do
    it 'should create a new connection' do
      lambda do
        connection.refresh
      end.should change(Connection.all, :count).by(0)
      Connection.where(:id => connection.id).should be_empty
    end
    
    it 'should destroy itself' do
      connection.refresh
      Connection.find_by_id(connection.id).should be_nil
    end
  end
  
  describe 'token' do
    it 'should generate a token' do
      connection.access_token.should_not be_nil
    end
    
    it 'should generate two different keys' do
      connection.access_token.should_not eql(Connection.create!.access_token)
    end
  end
  
  describe 'expire_at' do
    it 'should define the value' do
      Timecop.freeze(Time.now) do
        connection.expires_at.should eql(1.hour.from_now)
      end
    end
  end
end
