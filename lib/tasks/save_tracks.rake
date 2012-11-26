require './lib/save_tracks'

desc "Get the freshest tracks from HoC"
namespace :hoc do
  task :tracks => [:environment] do |t, args|
    #feed = EXAMPLE_FEED
    track_count = Track.count
    puts "Scraping HoC feed..."
    s = SaveTracks.new
    s.house_of_chi
    puts "Finished. #{Track.count - track_count} new tracks added."
  end
end

namespace :oneoff do
  task :update_youtube_video_ids => [:environment] do |t, args|
    Track.where(source: 'youtube').each do |track|
      track.update_attribute(:source_track_id, track.url.split('=')[1])
    end
  end
end
