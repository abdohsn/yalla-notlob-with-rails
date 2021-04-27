Rails.application.routes.draw do
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # devise_for :users, controllers: {omniauth_callbacks: 'omniauth'}
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # devise_scope :user do
  #   root 'devise/sessions#new'
  # end
  # authenticated :user do
  #   root 'home#index', as: 'authenticated_root'
  # end
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
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "home#index"

  
end

