#require 'rake'
require 'spec_helper'
require './lib/save_tracks'

describe 'SaveTracks' do
  describe '#create_tracks' do
    it "grabs all the feed items with youtube/soundcloud links for the HoC group" do
      s = SaveTracks.new
      f = File.read('./lib/example_feed.json')
      s.stub(:group_feed).and_return(JSON.parse(f))
      s.class.stub(:get).and_return(
        OpenStruct.new(response: OpenStruct.new(code: '503'))
      )
      s.house_of_chi
      expect(Track.count).to eq(17)
    end

    it "grabs the urls out of comments too" do
      s = SaveTracks.new
      f = File.read('./spec/lib/example_feed_with_comments.json')
      s.stub(:group_feed).and_return(JSON.parse(f))
      s.class.stub(:get).and_return(
        OpenStruct.new(response: OpenStruct.new(code: '503'))
      )
      s.house_of_chi
      expect(Track.count).to eq(28)
    end
  end

  describe "#source_site" do
    it "extracts the source site from the given link" do
      s = SaveTracks.new
      expect(s.source_site("http://youtube.com/watch/v=5lahyssah")).to eq("youtube")
      expect(s.source_site("http://youtu.be/4f_fWJbYkdk")).to eq("youtube")
    end
  end

  describe "#create_new_users" do
    it "returns the user if the user already exists" do
      User.create!(name: 'kori', uid: 'test_user', provider: 'fb')
      User.count.should == 1
      expect(User.find_or_create('test_user', 'kori', 'fb').name).to eq('kori')
    end

    it "creates and returns the user if the user doesn't exist" do
      expect(User.find_or_create('test_user', 'kori', 'fb').name).to eq('kori')
    end

    it "creates new users" do
      s = SaveTracks.new
      users = [{ 'name' => 'kori', 'id' => '154' }, { 'name' => 'james', 'id' => '4' }]
      expect{s.create_new_users(users)}.to change{User.count}.by(2)
    end
  end
end
