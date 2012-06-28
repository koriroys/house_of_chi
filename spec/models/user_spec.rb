require 'spec_helper'

describe User do
  describe "#from_omniauth" do
    it "returns a user if that user already exists, else creates a user" do
      count = User.count
      auth = { provider: 'fb', uid: '4444', info: { name: 'kori' } }.as_json
      auth2 = { provider: 'fb', uid: '111', info: { name: 'cristy' } }.as_json
      user = User.from_omniauth(auth)
      User.count.should == count + 1
      User.from_omniauth(auth).should == user
      User.count.should == count + 1
      User.from_omniauth(auth2)
      User.count.should == count + 2
    end
  end
end
