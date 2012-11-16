class TracksController < ApplicationController

  def index
    @tracks = Track.text_search(params[:query]).page(params[:page]).per(25).recent_first
  end

  def user
    @user = User.find params[:id]
    @tracks = @user.tracks.page(params[:page]).with_users
  end

end
