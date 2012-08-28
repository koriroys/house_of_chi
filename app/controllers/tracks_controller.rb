class TracksController < ApplicationController

  def index
    @tracks = Track.get_all
  end

  def user
    @user = User.find params[:id]
    @tracks = @user.tracks.get_all
  end

end
