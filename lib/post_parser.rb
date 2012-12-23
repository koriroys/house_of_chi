class PostParser
  def initialize(options)
    self.raw_posts = options[:raw_posts][:data]
  end

  def process
    tracks = raw_posts.each.with_object([]) do |post, tracks|
      tracks << PostTrackInfo.new(post: post)
    end
    tracks.select{ |t| matches(t.url) }
  end

  def matches(url)
    url.match(/https?:\/\/w*\.?(youtu\.be|youtube|soundcloud)(\.com)?/)
  end

  private
  attr_accessor :raw_posts
end

class PostTrackInfo
  attr_reader :source, :url, :user_id, :posted_on, :title, :source_track_id
  def initialize(options={post: {}})
    self.post            = options[:post]
    self.source          = post[:source]          || ''
    self.url             = post[:link]            || ''
    self.user_id         = post[:user_id]         || ''
    self.posted_on       = post[:posted_on]       || ''
    self.title           = post[:title]           || ''
    self.source_track_id = post[:source_track_id] || ''
  end

  private
  attr_accessor :post
  attr_writer :source, :url, :user_id, :posted_on, :title, :source_track_id
end

#Track(id: integer,
#      source: string,
#      url: string,
#      user_id: integer,
#      posted_on: datetime,
#      created_at: datetime,
#      updated_at: datetime,
#      title: string,
#      source_track_id: string)
