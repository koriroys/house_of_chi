class TracksController < ApplicationController

  def index
    @tracks = Track.get_all
  end

end
