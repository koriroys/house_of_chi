require 'post'
require 'httparty'

class SaveTracks
  include HTTParty

  HOC_GROUP_NUMBER = '179298008840024'
  SOURCE_SITE = { 'youtube' => 'youtube', 'youtu.be' => 'youtube', 'soundcloud' => 'soundcloud' }

  #TODO: better names.
  def house_of_chi
    feed = group_feed(HOC_GROUP_NUMBER)
    create_new_users(feed.map {|item| item['from'] }.uniq)
    create_tracks_from_feed(feed)
    create_tracks_from_comments(extract_comments(feed))
  end

  def extract_comments(feed)
    feed.map do |item|
      if item['comments']
        item['comments']['data']
      end
    end.flatten
  end

  def create_tracks_from_comments(comments)
    users = comments.compact.map{ |comment| comment['from'] if comment['from'] }.compact
    create_new_users(users)
    comments.compact.each do |comment|
      user = User.find_by_uid(comment['from']['id'])
      url = url_extractor(comment['message'])
      source_site = source_site_extractor(comment['message'])
      if SOURCE_SITE.include?(source_site)
        unless Track.already_exists?(url, user.id)
          create_track(source_site, url, user, comment['created_time'], 'unknown')
        end
      end
    end
  end

  def url_extractor(link)
    link.match(/http:\/\/[^&|\s]*/).to_s
  end

  def source_site_extractor(link)
    match = link.match(/youtube|soundcloud|youtu\.be/).to_s
    match == 'youtu.be' ? 'youtube' : match
  end

  #TODO: item rename to 'post'
  def create_tracks_from_feed(feed)
    posts = feed.map{ |post| Post.new(post) }.select{ |p| p.source_site.present? }
    posts.each do |post|
      user = User.find_by_uid(post.user_fb_id)
      unless Track.already_exists?(post.url, user.id)
        create_track(post.source_site, post.url, user, post.posted_on, post.title)
      end

      # comments section
      # TODO: clean up duplicate code
      # next line here because example data is stale eg doesn't have 'comments'
      if post.comments && post.comments['data'].present?
        comments(post.comments['data'])
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

  #TODO: extraction
  def comments(data)
    create_new_users(data.map {|item| item['from'] }.uniq)

    data.each do |comment|
      user = User.find_by_uid(comment['from']['id'])
      url = comment['message'].match(/http:\/\/[^&|\s]*/).to_s
      source_site = comment['message'].match(/youtube|soundcloud|youtu\.be/).to_s
      if url.present? && SOURCE_SITE.has_key?(source_site)
        unless Track.already_exists?(url, user.id)
          create_track(SOURCE_SITE[source_site], url, user, comment['created_time'], 'what')
        end
      end
    end
  end

  def create_new_users(users)
    users.each { |user| User.find_or_create(user['id'], user['name'], 'fb') }
  end

  def group_feed(group_id)
    ## my fb_user_id
    user = User.find_by_uid('13708826')
    graph = Koala::Facebook::API.new(user.fb_token)
    ## house of chi feed
    graph.get_connections(group_id, 'feed?since=yesterday&limit=20', { fields: 'from,link,created_time,name,comments' })
  end
end
