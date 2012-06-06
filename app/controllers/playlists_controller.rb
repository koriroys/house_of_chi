class PlaylistsController < ApplicationController

  def index
    graph = Koala::Facebook::API.new(session[:fb_token])
    @array = graph.get_connections('179298008840024', 'feed', {fields: 'id,from,link,created_time'})
    @hoc = @array.map{ |item| item if item['link'] =~ /youtube|soundcloud/i }.compact
  end

end
