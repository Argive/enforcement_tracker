Rails.application.routes.draw do
  root "static_pages#root"

  namespace :api, defaults: {formal: :json} do
    namespace :v1 do
      resources :facilities, only: [:index, :show]
      resources :inspections, only: [:index, :show]
      resources :enforcements, only: [:index, :show]
    end
  end
end
