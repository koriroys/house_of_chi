HouseOfChiPlaylist::Application.routes.draw do
  root to: 'static_pages#index'

  get '/tracks' => 'tracks#index'
  get '/playlists' => 'playlists#index'
  get '/feed' => 'playlists#feed'

  get '/auth/facebook/callback' => 'sessions#create'
  match 'auth/failure', to: redirect('/')
  get 'signout' => 'sessions#destroy', as: 'signout'
  

end
