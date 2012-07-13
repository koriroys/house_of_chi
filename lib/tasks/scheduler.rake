desc "Get the freshest tracks from HoC"
namespace :hoc do
  task :tracks => :environment do
    puts "Scraping HoC feed..."
    # my fb_user_id
    user = User.find_by_uid('13708826')
    graph = Koala::Facebook::API.new(user.fb_token)
    # house of chi feed
    feed = graph.get_connections('179298008840024', 'feed?since=yesterday&limit=100', { fields: 'id,from,link,created_time' })
    puts feed
    puts "done."
  end
end
