Rails.application.routes.draw do
  root 'shareco#index'
  devise_for :users
  devise_scope :user do
    post 'users/guest_login', to: 'users/sessions#guest_login'
  end
  get 'users/account'
  resources :shareco
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
