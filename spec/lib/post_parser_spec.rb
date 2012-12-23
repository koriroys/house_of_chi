directory = File.dirname(__FILE__)
require File.join(directory, %w(.. .. lib post_parser))
require 'json'

describe PostParser do
  it 'takes a json list of posts and returns a list of tracks to create' do
    raw_posts = JSON.parse(File.read(File.join(directory, %w(.. fixtures posts.json))), symbolize_names: true)
    p = PostParser.new(raw_posts: raw_posts)
    tracks = p.process
    #puts tracks.map(&:inspect)
    expect(tracks.count).to eq(31)
    expect(tracks.first.url).to eq('https://soundcloud.com/ssma/solomun-mixmag-stream-2012-12')
  end
end

describe PostTrackInfo do
  it 'has all the attributes needed to create a Track' do
    p = PostTrackInfo.new
    expect(p).to respond_to(:source)
    expect(p).to respond_to(:url)
    expect(p).to respond_to(:user_id)
    expect(p).to respond_to(:posted_on)
    expect(p).to respond_to(:title)
    expect(p).to respond_to(:source_track_id)
  end
end
