directory = File.dirname(__FILE__)
require File.join(directory, %w(.. .. lib post_parser))
require 'json'

describe PostParser do
  it 'takes a json list of posts and returns a list of tracks to create' do
    posts = JSON.parse(File.read(File.join(directory, %w(.. fixtures posts.json))))
    p = PostParser.new(posts: posts)
    tracks = p.process
    expect(tracks.count).to eq(2)
  end
end
