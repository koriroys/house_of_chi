#require 'rake'
require 'spec_helper'
require './lib/save_tracks'

describe 'SaveTracks' do
  it "grabs all the feed items with youtube/soundcloud links for the HoC group" do
    s = SaveTracks.new
    f = File.read('./lib/example_feed.json')
    s.stub(:hoc_feed).and_return(JSON.parse(f))

    s.house_of_chi
    expect(Track.count).to eq(17)
  end

  it "grabs the urls out of comments too" do
    s = SaveTracks.new
    f = File.read('./spec/lib/example_feed_with_comments.json')
    s.stub(:hoc_feed).and_return(JSON.parse(f))

    s.house_of_chi
    expect(Track.count).to eq(23)
  end
end
