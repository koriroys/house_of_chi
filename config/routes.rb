HouseOfChiPlaylist::Application.routes.draw do
  root to: 'static_pages#index'

  get '/tracks' => 'tracks#index'
  get '/playlists' => 'playlists#index'
  get '/feed' => 'playlists#feed'
  get '/tracks/user/:id' => 'tracks#user', as: 'user_tracks'

  get 'login' => 'sessions#redirect'
  get '/auth/facebook/callback' => 'sessions#create'
  match 'auth/failure', to: redirect('/')
  get 'signout' => 'sessions#destroy', as: 'signout'

end
