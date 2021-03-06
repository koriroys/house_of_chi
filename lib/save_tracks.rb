require 'post'
require 'httparty'

class SaveTracks
  include HTTParty

  HOC_GROUP_NUMBER = '179298008840024'

  #TODO: better names.
  def house_of_chi
    feed = group_feed(HOC_GROUP_NUMBER)
    UserCreator.new(feed).create_users

    posts = extract_posts(feed)
    create_tracks_from_posts(posts)

    comments = extract_comments_from_feed(feed)
    comments.map!{ |comment| Comment.new(comment) }
    comments.select!{ |c| c.source_site.present? }
    create_tracks_from_comments(comments)
  end

  def extract_posts(feed)
    feed.map{ |post| Post.new(post) }.select{ |p| p.source_site.present? }
  end

  def extract_comments_from_feed(feed)
    feed.select{ |post| post['comments'].present? }.map{ |post| post['comments']['data'] }.flatten.compact
  end

  def create_tracks_from_comments(comments)
    comments.each do |c|
      user = User.find_by_uid(c.from_id)
      unless Track.already_exists?(c.url, user.id)
        create_track(c.source_site, c.url, user, c.posted_on, nil)
      end
    end
  end

  def create_tracks_from_posts(posts)
    posts.each do |post|
      user = User.find_by_uid(post.user_fb_id)
      unless Track.already_exists?(post.url, user.id)
        create_track(post.source_site, post.url, user, post.posted_on, post.title)
      end
    end
  end

  def create_track(source_site, url, user, posted_on, title)
    if query = URI(url).query
      video_id = query.split("&").map{|q| q.split("=")}.select{|e| e[0] == "v"}.flatten.last
    elsif url.match(/youtu\.be/)
      video_id = url.split("/").last.split("?").first
    end
    title = title || get_title_from_youtube(source_site, video_id) || 'ID'
    Track.create(source: source_site, url: url, user: user, posted_on: posted_on, title: title, source_track_id: video_id)
  end

  def youtube_uri(video_id)
    "https://www.googleapis.com/youtube/v3/videos?id=#{video_id}&key=#{ENV['GOOGLE_API_KEY']}&part=snippet&fields=items(snippet/title)"
  end

  def get_title_from_youtube(source_site, video_id)
    if source_site == 'youtube'
      uri = youtube_uri(video_id)
      response = self.class.get(uri)
      if response.response.code != '503' && response['items'].present?
        return response['items'].first['snippet']['title']
      end
    end
  end

  def group_feed(group_id)
    ## my fb_user_id
    user = User.find_by_uid('13708826')
    graph = Koala::Facebook::API.new(user.fb_token)
    fields = 'from,link,created_time,name,comments'
    options = 'feed?since=yesterday&limit=200'
    ## house of chi feed
    graph.get_connections(group_id, options, { fields: fields})
  end
end
