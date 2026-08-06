Rails.application.routes.draw do
  resources :languages
  resources :websites do
    resources :groups, controller: "websites/groups" do
      member do
        get :select_pages
        post :select_pages, to: "websites/groups#do_select_pages"
      end
    end
    resources :pages, controller: "websites/pages"
  end

  get "up" => "rails/health#show", as: :rails_health_check
  root to: "home#index"
end
