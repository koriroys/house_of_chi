require 'post'
require 'httparty'

class SaveTracks
  include HTTParty

  HOC_GROUP_NUMBER = '179298008840024'

  #TODO: better names.
  def house_of_chi
    feed = group_feed(HOC_GROUP_NUMBER)
    create_new_users(feed.map {|item| item['from'] }.uniq)
    create_tracks_from_feed(feed)
    create_tracks_from_comments(extract_comments(feed))
  end

  def extract_comments(feed)
    feed.map do |post|
      if post['comments']
        post['comments']['data']
      end
    end.flatten.compact
  end

  def create_tracks_from_comments(comments)
    create_new_users(comments.map {|item| item['from'] }.uniq)
    comments = comments.map{ |comment| Comment.new(comment) }.
      select{ |c| c.source_site.present? }

    comments.each do |c|
      user = User.find_by_uid(c.from_id)
      unless Track.already_exists?(c.url, user.id)
        create_track(c.source_site, c.url, user, c.posted_on, 'what')
      end
    end
  end

  def create_tracks_from_feed(feed)
    posts = feed.map{ |post| Post.new(post) }.select{ |p| p.source_site.present? }
    posts.each do |post|
      user = User.find_by_uid(post.user_fb_id)
      unless Track.already_exists?(post.url, user.id)
        create_track(post.source_site, post.url, user, post.posted_on, post.title)
      end
    end
  end

  def create_track(source_site, url, user, posted_on, title)
    if source_site == 'youtube'
      video_id = url.split('=')[1]
      response = self.class.get("https://www.googleapis.com/youtube/v3/videos?id=#{video_id}&key=#{ENV['GOOGLE_API_KEY']}&part=snippet&fields=items(snippet/title)")
      unless response.response.code == '503'
        new_title = response['items'].first['snippet']['title'] unless response['items'].empty?
      end
      Track.create(source: source_site, url: url, user: user, posted_on: posted_on, title: new_title || title, source_track_id: video_id)
    else
      Track.create(source: source_site, url: url, user: user, posted_on: posted_on, title: title)
    end
  end

  def create_new_users(users)
    users.each { |user| User.find_or_create(user['id'], user['name'], 'fb') }
  end

  def group_feed(group_id)
    ## my fb_user_id
    user = User.find_by_uid('13708826')
    graph = Koala::Facebook::API.new(user.fb_token)
    fields = 'from,link,created_time,name,comments'
    options = 'feed?since=yesterday&limit=20'
    ## house of chi feed
    graph.get_connections(group_id, options, { fields: fields})
  end
end
