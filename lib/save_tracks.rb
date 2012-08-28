class SaveTracks
  HOC_GROUP_NUMBER = '179298008840024'

  def house_of_chi
    feed = filter_links(hoc_feed)
    create_new_users(feed)
    create_tracks_from_feed(feed)
  end

  def filter_links(feed)
    feed.select {|item| item['link'] =~ /youtube|soundcloud/i }
  end

  def create_tracks_from_feed(feed)
    feed.each do |item|
      user = User.find_by_uid(item['from']['id'])
      source_site = item['link'].match(/youtube|soundcloud/).to_s
      if source_site == 'youtube'
        url = item['link'].match(/([^&]*)/)[1].to_s
      else
        url = item['link']
      end
      unless Track.exists(url, user.id).present?
        Track.create(source: source_site, url: url, user: user, posted_on: item['created_time'])
      end
    end
  end

  def create_new_users(feed)
    feed.map {|item| item['from'] }.uniq.each do |user|
      User.create(name: user['name'], uid: user['id'], provider: 'fb') unless User.find_by_uid(user['id'])
    end
  end

  def hoc_feed
    ## my fb_user_id
    user = User.find_by_uid('13708826')
    graph = Koala::Facebook::API.new(user.fb_token)
    ## house of chi feed
    graph.get_connections(HOC_GROUP_NUMBER, 'feed?since=yesterday&limit=200', { fields: 'id,from,link,created_time' })
  end
end
