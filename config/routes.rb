Rails.application.routes.draw do
  root 'shareco#index'
  resources :shareco
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
