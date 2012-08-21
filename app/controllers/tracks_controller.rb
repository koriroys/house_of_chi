class TracksController < ApplicationController

  def index
    @tracks = Track.find(:all, order: 'posted_on DESC')
  end

end
