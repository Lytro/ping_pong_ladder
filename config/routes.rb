Pong::Application.routes.draw do
  resources :achievements, only: [:index]
  resources :matches do
    collection do
      get 'rankings'
      get 'players'
    end
  end
  resources :updates, only: [:index]
  resources :players, only: [:show, :update] do
    collection do
      get 'odds'
    end
  end
  resource :api do
    member do
      get 'tweet'
    end
  end
  root to: 'matches#rankings'
end
