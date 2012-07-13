class PlaylistsController < ApplicationController
  
  before_filter :establish_fb_connection

  def index
    @array = @graph.get_connections(params[:group_id], 'feed?since=yesterday&limit=100', {fields: 'id,from,link,created_time'})
  rescue Koala::Facebook::APIError
    redirect_to root_url, notice: "Please log in to see playlists!"
  else
    @hoc = @array.map{ |item| item if item['link'] =~ /youtube|soundcloud/i }.compact
    # just peel out the youtube video id
    # link.slice(/(v=)(\w*)/, 2)
  end
  
  def feed
    graph = Koala::Facebook::API.new(session[:fb_token])
    @feed = graph.get_connections(params[:group_id], 'feed?since=yesterday&limit=100')
    render json: [ @feed.size, @feed ]
  end

end
