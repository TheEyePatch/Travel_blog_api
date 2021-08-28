Rails.application.routes.draw do
  namespace :users do
    devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions'}
    get ':username', to: 'users#show'
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :blogs
  resources :user_blogs
end
