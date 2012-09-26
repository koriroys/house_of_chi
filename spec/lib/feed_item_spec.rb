require 'spec_helper'
require './lib/feed_item'

describe "FeedItem" do
  context "initializer basics" do
    before do
      feed_item = JSON.parse(File.read('./lib/example_feed.json')).first
      @f = FeedItem.new(feed_item)
    end

    it "responds to user_id" do
      expect(@f.user_fb_id).to eq("1511783857")
    end

    it "responds to posted_on" do
      expect(@f.posted_on).to eq("2012-08-21T03:50:25+0000")
    end

    it "responds to source_site" do
      expect(@f.source_site).to eq("youtube")
    end

    it "responds to url" do
      expect(@f.url).to eq("http://www.youtube.com/watch?v=x4P-TK7W7A8")
    end

    it "sets title to ID if no title present" do
      expect(@f.title).to eq("ID")
    end
  end

  it "sets the source site correctly" do
    item = {
      from:
        { id: "don't care"},
      link: "http://youtu.be.com/watch/v=random",
      created_time: "don't care",
      name: 'Fake track'
    }.as_json
    f = FeedItem.new(item)
    expect(f.source_site).to eq("youtube")
  end
end

#{"id"=>"179298008840024_256627731107051", "from"=>{"name"=>"Marco Sgalbazzini", "id"=>"1511783857"}, "link"=>"http://www.youtube.com/watch?v=x4P-TK7W7A8", "created_time"=>"2012-08-21T03:50:25+0000", "updated_time"=>"2012-08-21T20:24:46+0000"}
