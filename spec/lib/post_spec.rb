require 'spec_helper'

class Dummy
  include UrlExtractor
end

describe UrlExtractor do
  let(:dummy) { Dummy.new }

  it 'extracts urls correctly' do
    expect(dummy.url_extractor('http://google.com')).to eq('http://google.com')
    expect(dummy.url_extractor('https://google.com')).to eq('https://google.com')
    expect(dummy.url_extractor('https://google.com?whatever')).to eq('https://google.com?whatever')
    expect(dummy.url_extractor('https://google.com?whatever&more_stuff')).to eq('https://google.com?whatever')
  end
end

describe Post do
  context "initializer basics" do
    let(:post_data) { JSON.parse(File.read('./lib/example_feed.json')).first }
    let(:post) { Post.new(post_data) }

    it "responds to user_id" do
      expect(post.user_fb_id).to eq("1511783857")
    end

    it "responds to posted_on" do
      expect(post.posted_on).to eq("2012-08-21T03:50:25+0000")
    end

    it "responds to source_site" do
      expect(post.source_site).to eq("youtube")
    end

    it "responds to url" do
      expect(post.url).to eq("http://www.youtube.com/watch?v=x4P-TK7W7A8")
    end

    it "sets title to ID if no title present" do
      expect(post.title).to eq("ID")
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
    expect(Post.new(item).source_site).to eq("youtube")
  end
end
