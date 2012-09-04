class SaveTracks
  HOC_GROUP_NUMBER = '179298008840024'
  SOURCE_SITE = { 'youtube' => 'youtube', 'youtu.be' => 'youtube', 'soundcloud' => 'soundcloud' }

  #TODO: better names.
  def house_of_chi
    feed = filter_links(hoc_feed)
    create_new_users(feed)
    create_tracks_from_feed(feed)
  end

  def filter_links(feed)
    feed.select {|item| item['link'] =~ /youtube|soundcloud/i }
  end

  #TODO: item rename to 'post'
  def create_tracks_from_feed(feed)
    feed.each do |item|
      user = User.find_by_uid(item['from']['id']) # item.from_id
      source_site = item['link'].match(/youtube|soundcloud/).to_s #item.source_site
      #TODO: conditional => method
      if source_site == 'youtube'
        url = item['link'].match(/([^&]*)/)[1].to_s
      else
        url = item['link']
      end
      unless Track.exists(url, user.id).present?
        Track.create(source: source_site, url: url, user: user, posted_on: item['created_time'], title: item['name'])
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

  #TODO: extraction
  def comments(data)
    create_new_users(data)

    data.each do |comment|
      user = User.find_by_uid(comment['from']['id'])
      url = comment['message'].match(/http:\/\/\S*/).to_s
      source_site = comment['message'].match(/youtube|soundcloud|youtu\.be/).to_s
      if url.present? && SOURCE_SITE.has_key?(source_site)
        unless Track.exists(url, user.id).present?
          Track.create(source: SOURCE_SITE[source_site], url: url, user: user, posted_on: comment['created_time'], title: comment['name'])
        end
      end
    end
  end

  def create_new_users(feed)
    feed.map {|item| item['from'] }.uniq.each do |user|
      #TODO: User.find_or_create_by(id)
      User.create(name: user['name'], uid: user['id'], provider: 'fb') unless User.find_by_uid(user['id'])
    end
  end

  def hoc_feed
    ## my fb_user_id
    user = User.find_by_uid('13708826')
    graph = Koala::Facebook::API.new(user.fb_token)
    ## house of chi feed
    graph.get_connections(HOC_GROUP_NUMBER, 'feed?since=yesterday&limit=200', { fields: 'id,from,link,created_time,name,comments' })
  end
end
