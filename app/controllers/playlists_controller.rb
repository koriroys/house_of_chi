class PlaylistsController < ApplicationController

  FB_ACCESS_TOKEN = 'AAACEdEose0cBANk2STnqZC8B20DBXnAdtDGi0ZBDJEvBa6ZCjiIVYsFfJ6J8PtwFPsUuCYIhP1xtpmKlE6soZAdFDXznEFfryHUD5HtM2AZDZD'

  def index
    @playlists = []
    graph = Koala::Facebook::API.new(FB_ACCESS_TOKEN)
    @array = graph.get_connections('179298008840024', 'feed', {fields: 'id,from,link,created_time'})
    @hoc = @array.map{ |item| item if item['link'] =~ /youtube|soundcloud/i }.compact
  end

  def login
    @fb_access_token = 'AAACEdEose0cBABCXdlpLNKQZBWEzZBiqFN8A1ZBH7HiKrlwS7HDLQd0kKDcqzzwM9ag3gxcplajdBjZAp01LmZAacRoweM9sucGSQD57UcgZDZD'
    respond_to do |format|
      format.json { render json: @fb_access_token }
    end
  end

end
