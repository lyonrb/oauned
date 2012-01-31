require 'spec_helper'

describe Oauned::Strategy do
  let(:user) { User.create! }
  let(:connection) { Connection.create!(user: user) }

  it "loads a page when provided a valid token" do
    get '/me',
      :access_token => connection.access_token,
      :format => :json
    response.should be_success
    response.body.should eql(user.to_json)
  end

  it "should fail if we don't provide any token" do
    get '/me', :format => :json
    response.status.should eql(401)
  end

  it "should fail if we provide an invalid token" do
    get '/me',
      :format => :json,
      :access_token => 'abcd'
    response.status.should eql(401)
  end
end
