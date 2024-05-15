Rails.application.routes.draw do
  root 'home#index'
  resources :registrations
  resources :sessions, only: [:new, :create]
  resources :transactions, only: [:create]
  post 'transactions/create', to: 'transactions#create_transaction', as: :create_transaction
  resources :products do
    patch :update_stock, on: :member
  end
  resources :users
  delete 'logout' => 'sessions#destroy', as: :logout
  match '*unmatched', to: 'application#not_found_method', via: :all
  get "up" => "rails/health#show", as: :rails_health_check
end

