Rails.application.routes.draw do
  resources :websites do
    member do
      get :crawl
    end
    resources :groups, controller: "websites/groups" do
      member do
        get :migrate
        get :migrate_job
        get :select_pages
        post :select_pages, to: "websites/groups#do_select_pages"
      end
    end
    resources :pages, controller: "websites/pages" do
      member do
        get :migrate
      end
    end
    resources :languages, controller: "websites/languages"
    resources :medias, controller: "websites/medias", only: [:index, :show]
  end

  get "up" => "rails/health#show", as: :rails_health_check
  root to: "home#index"
end
