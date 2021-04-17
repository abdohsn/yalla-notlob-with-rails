Rails.application.routes.draw do
  resources :orders do
    resources :orders_details
  end
 
end
