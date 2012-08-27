require './lib/save_tracks'

desc "Get the freshest tracks from HoC"
namespace :hoc do
  task :tracks => [:environment] do |t, args|
    #feed = EXAMPLE_FEED
    puts "Scraping HoC feed..."
    s = SaveTracks.new
    s.house_of_chi
    puts "done."
  end
end
