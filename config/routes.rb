Rails.application.routes.draw do
  resources :languages
  resources :websites do
    resources :groups, controller: "websites/groups"
  end

  get "up" => "rails/health#show", as: :rails_health_check
  root to: "home#index"
end
