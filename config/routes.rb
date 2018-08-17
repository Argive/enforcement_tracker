Rails.application.routes.draw do
  root "static_pages#root"

  namespace :api, defaults: {formal: :json} do
    resources :facilities, only: [:index, :show]
    resources :inspections, only: [:index, :show]
    resources :enforcements, only: [:index, :show]
  end
end
