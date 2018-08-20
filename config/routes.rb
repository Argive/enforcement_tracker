Rails.application.routes.draw do
  root "static_pages#root"

  namespace :api, defaults: {formal: :json} do
    namespace :v1 do
      resources :facilities, only: [:index, :show] do
        collection do
          get 'summarize'
        end
      end

      resources :inspections, only: [:index, :show] do
        collection do
          get 'summarize'
        end
      end

      resources :enforcements, only: [:index, :show] do
        collection do
          get 'summarize'
        end
      end

    end
  end
end
