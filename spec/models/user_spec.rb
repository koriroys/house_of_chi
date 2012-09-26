require 'spec_helper'

describe User do
  let (:auth) { { provider: 'fb', uid: '4444', info: { name: 'kori' } }.as_json }

  describe "#create_from_omniauth" do
    it "creates a new user given auth information" do
      expect{ User.create_from_omniauth auth }.to change(User, :count).by(1)
    end
  end

  describe "#from_omniauth" do
    it "returns a user if that user already exists" do
      user = User.from_omniauth auth
      expect{ User.from_omniauth auth }.not_to change(User, :count)
      expect(User.from_omniauth auth).to eq(user)
    end

    it "creates a user if that user does not yet exist" do
      auth2 = { provider: 'fb', uid: '4441', info: { name: 'sylvia' } }.as_json
      expect{ User.from_omniauth auth2 }.to change(User, :count).by(1)
    end
  end

  describe "find_or_create" do
    it "returns the user if the user already exists" do
      User.create!(name: 'kori', uid: 'test_user', provider: 'fb')
      User.count.should == 1
      expect(User.find_or_create('test_user', 'kori', 'fb').name).to eq('kori')
    end

    it "creates and returns the user if the user doesn't exist" do
      expect(User.find_or_create('test_user', 'kori', 'fb').name).to eq('kori')
    end
  end
end
