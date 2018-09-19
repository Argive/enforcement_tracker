Rails.application.routes.draw do
  root "static_pages#root"

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      concern :pagination do
        get '(page/:page)', action: :index, on: :collection, as: ''
      end

      resources :facilities, only: [:show], concerns: :pagination do
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
          get 'summarize_v2'
        end
      end

    end
  end
end
