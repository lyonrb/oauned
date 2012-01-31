require 'spec_helper'

describe Oauned::Models::Oauthable do
  let(:user) { User.create! }
  let(:connection) { Connection.create!(user: user) }

  describe 'find_for_oauth_authentication' do

    it "should return the user corresponding the the access token" do
      User.find_for_oauth_authentication(connection.access_token).id.should eql(user.id)
    end

    it "should return nil if provided an invalid access token" do
      User.find_for_oauth_authentication('abcd').should be_nil
    end

    it "should return nil if provided an expired access token" do
      connection
      Timecop.freeze(6.months.from_now) do
        User.find_for_oauth_authentication(connection.access_token).should be_nil
      end
    end
  end
end
