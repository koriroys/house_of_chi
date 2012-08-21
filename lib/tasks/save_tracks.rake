desc "Get the freshest tracks from HoC"
namespace :hoc do
  task tracks: [:environment, :example] do |t, args|
    HOC_GROUP_NUMBER = '179298008840024'
    #feed = EXAMPLE_FEED
    #puts "Scraping HoC feed..."
    ## my fb_user_id
    user = User.find_by_uid('13708826')
    graph = Koala::Facebook::API.new(user.fb_token)
    ## house of chi feed
    feed = graph.get_connections(HOC_GROUP_NUMBER, 'feed?since=yesterday&limit=200', { fields: 'id,from,link,created_time' })
    feed.select! {|item| item['link'] =~ /youtube|soundcloud/i }

    feed.map {|item| item['from'] }.uniq.each do |user|
      User.create(name: user['name'], uid: user['id'], provider: 'fb') unless User.find_by_uid(user['id'])
    end

    feed.each do |item|
      user = User.find_by_uid(item['from']['id'])
      match = item['link'].match(/youtube|soundcloud/).to_s
      unless Track.exists(item['link'], user.id).present?
        Track.create(source: match, url: item['link'], user: user, posted_on: item['created_time'])
      end
    end

    #t.string   "source"
    #t.string   "url"
    #t.string   "added_by"
    #t.datetime "posted_on"
    #t.datetime "created_at", :null => false
    #t.datetime "updated_at", :null => false

    puts "done."
  end
  task :example do
    require "#{File.dirname(__FILE__)}/../example_feed"
  end
end
