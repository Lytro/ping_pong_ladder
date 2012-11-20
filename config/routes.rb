Pong::Application.routes.draw do
  resources :achievements, only: [:index]
  resources :matches do
    collection do
      get 'rankings'
      get 'players'
    end
  end
  resources :updates, :only => [:index]
  resources :players, :only => [:show]
  root to: 'matches#rankings'
end
