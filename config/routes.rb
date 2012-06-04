HouseOfChiPlaylist::Application.routes.draw do
  root :to => 'playlists#index'

  get '/tracks' => 'tracks#index'
end
