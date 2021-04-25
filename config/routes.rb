Rails.application.routes.draw do
  post "/addfriend", to: "order_members#create"

  
  resource :friends
  resources :groups do
    post 'getName'
    post 'addFriend'
    delete 'deletefriend'
end

  get 'orders_details/index'
  resource :friends
  
  resources :orders do
    resources :orders_details
  end
 
  get 'home/index'
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth'}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "home#index"




end

