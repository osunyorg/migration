Rails.application.routes.draw do
  resources :websites

  get "up" => "rails/health#show", as: :rails_health_check
  root to: "websites#index"
end
