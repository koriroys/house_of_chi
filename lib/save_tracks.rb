require 'feed_item'

class SaveTracks
  HOC_GROUP_NUMBER = '179298008840024'
  SOURCE_SITE = { 'youtube' => 'youtube', 'youtu.be' => 'youtube', 'soundcloud' => 'soundcloud' }

  #TODO: better names.
  def house_of_chi
    feed = filter_links(group_feed(HOC_GROUP_NUMBER))
    create_new_users(feed.map {|item| item['from'] }.uniq)
    create_tracks_from_feed(feed)
  end

  def filter_links(feed)
    feed.select {|item| item['link'] =~ /youtube|soundcloud|youtu\.be/i }
  end

  #TODO: item rename to 'post'
  def create_tracks_from_feed(feed)
    feed.each do |item|
      feed_item = FeedItem.new(item)
      user = User.find_by_uid(feed_item.user_fb_id)
      source_site = feed_item.source_site
      url = extract_url(source_site, item)
      unless Track.already_exists?(url, user.id)
        create_track(source_site, url, user, item['created_time'], item['name'])
      end

      # comments section
      # TODO: clean up duplicate code
      # next line here because example data is stale eg doesn't have 'comments'
      if item['comments']
        if item['comments']['count'] > 0
          comments(item['comments']['data'])
        end
      end
    end
  end

  def create_track(source_site, url, user, posted_on, title)
    Track.create(source: source_site, url: url, user: user, posted_on: posted_on, title: title)
  end

  def extract_url(source_site, item)
    if source_site == 'youtube'
      item['link'].match(/([^&]*)/)[1].to_s
    else
      item['link']
    end
  end

  def source_site(url)
    SOURCE_SITE[url.match(/youtube|soundcloud|youtu\.be/).to_s] #item.source_site
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
          create_track(SOURCE_SITE[source_site], url, user, comment['created_time'], comment['name'])
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
    graph.get_connections(group_id, 'feed?since=yesterday&limit=200', { fields: 'id,from,link,created_time,name,comments' })
  end
end
