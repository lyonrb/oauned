require 'spec_helper'

describe Oauned::Models::Authorization do
  let(:application) { Application.create! }
  let(:user) { User.create! }
  let(:authorization) { Authorization.create!(:application => application, :user => user) }

  it 'should create the object' do
    lambda do
      Authorization.create!.new_record?.should be_false
    end.should change(Authorization, :count).by(1)
  end

  describe 'expires_in' do
    (0..10).each do |i|
      it "should return #{i}" do
        Timecop.freeze(Time.now) do
          authorization.update_attribute(:expires_at, i.seconds.from_now)
          authorization.expires_in.should eql(i)
        end
      end
    end
  end

  describe 'expired?' do
    it 'should be expired' do
      authorization.update_attribute(:expires_at, 1.seconds.from_now)
      authorization.expired?.should eql(true)
    end

    it 'should not be expired' do
      authorization.expired?.should eql(false)
    end
  end

  describe 'tokenize' do
    it 'should create a token' do
      lambda do
        authorization.tokenize!
      end.should change(Connection, :count).by(1)
    end

    it 'should destroy itself' do
      #lambda do
        authorization.tokenize!
      #end.should change(Authorization.all, :count).by(-1)
      Authorization.where(:id => authorization.id).should be_empty
    end
  end

  describe 'code' do
    it 'should generate a code' do
      authorization.code.should_not be_nil
    end

    it 'should generate two different keys' do
      authorization.code.should_not eql(Authorization.create!.code)
    end
  end

  describe 'expire_at' do
    it 'should define the value' do
      Timecop.freeze(Time.now) do
        authorization.expires_at.should eql(1.hour.from_now)
      end
    end
  end
end
