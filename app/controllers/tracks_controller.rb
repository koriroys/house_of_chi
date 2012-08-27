class TracksController < ApplicationController

  def index
    @tracks = Track.includes(:user).get_all
  end

end
