class StaticPagesController < ApplicationController
  def index
    @leaders = User.top_5_track_count
  end
end
