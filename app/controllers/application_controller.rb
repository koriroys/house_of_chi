class ApplicationController < ActionController::Base
  protect_from_forgery


  def establish_fb_connection
    @graph ||= Koala::Facebook::API.new(session[:fb_token])
  end

  def fetch_wall_posts(group_id)
    @graph.get_connections(group_id, 'feed?since=yesterday&limit=100', {fields: 'id,from,link,created_time'})
  end

  private #-------------------------------------------

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
