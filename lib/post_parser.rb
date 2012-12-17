class PostParser
  def initialize(options)
    self.raw_posts = options[:raw_posts][:data]
  end

  def process
    tracks = raw_posts.each.with_object([]) do |post, tracks|
      tracks << PostTrackInfo.new(post: post)
    end
    tracks.select{ |t| matches(t.link) }
  end

  def matches(link)
    link.match(/https?:\/\/w*\.?(youtu\.be|youtube|soundcloud)(\.com)?/)
  end

  private
  attr_accessor :raw_posts
end

class PostTrackInfo
  attr_reader :link
  def initialize(options)
    self.post = options[:post]
    self.link = post[:link] || ''
  end

  private
  attr_writer :link
  attr_accessor :post
end
