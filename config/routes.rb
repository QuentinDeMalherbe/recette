Rails.application.routes.draw do
  devise_for :users
  root to: 'listes#index'
  resources :preferences
  resources :listes do
    post 'liste_ingredient/', to: 'liste_ingredients#create_multiple'
    resources :liste_ingredients, shallow: true , only: [ :index, :update]
    resources :recipes, shallow: true do
    resources :ingredients, only: [:show]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
