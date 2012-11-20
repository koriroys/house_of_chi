class UsersController < ApplicationController
  def index
    @users = User.highest_track_count
  end
end
