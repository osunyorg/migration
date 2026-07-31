Rails.application.routes.draw do
  resources :languages
  resources :websites

  get "up" => "rails/health#show", as: :rails_health_check
  root to: "home#index"
end
