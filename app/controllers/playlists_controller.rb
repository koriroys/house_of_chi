class PlaylistsController < ApplicationController

  before_filter :establish_fb_connection

  def index
    @array = fetch_wall_posts(params[:group_id])
  rescue Koala::Facebook::APIError
    redirect_to root_url, notice: "Please log in to see playlists!"
  else
    @hoc = @array.map{ |item| item if item['link'] =~ /youtube|soundcloud/i }.compact
    # just peel out the youtube video id
    # link.slice(/(v=)(\w*)/, 2)
  end

  def feed
    graph = Koala::Facebook::API.new(session[:fb_token])
    @feed = graph.get_connections(params[:group_id], 'feed?since=yesterday&limit=200')
    render json: [ @feed.size, @feed ]
  end

end
