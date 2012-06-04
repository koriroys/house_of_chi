require 'spec_helper'

describe PlaylistsController do

  describe '#index' do
    it 'keeps you from getting into trouble' do
      get :index
      assigns(:playlists).should be_empty
    end
  end

  describe '#login' do
    it 'successfully gets an access token' do
      get :login
      assigns(:fb_access_token).should_not be_blank
    end
  end

end
