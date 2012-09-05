class TracksController < ApplicationController

  def index
    @tracks = Track.page(params[:page]).per(25).with_users
  end

  def user
    @user = User.find params[:id]
    @tracks = @user.tracks.page(params[:page]).with_users
  end

end
