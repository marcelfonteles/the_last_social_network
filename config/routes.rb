Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :users, except: :destroy do
        resource :inventories, only: :update
        resource :infected_users, path: 'infected', only: :update
      end

      resource :trades, only: :create
    end
  end
end
