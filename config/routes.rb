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
          get 'industry_count'
          get 'index_geo'
        end
      end

      resources :inspections, only: [:index, :show] do
        collection do
          get 'summarize'
          get 'tally_by_state'
        end
      end

      resources :enforcements, only: [:index, :show] do
        collection do
          get 'summarize'
          get 'tally_by_statute'
          get 'group_by_year'
        end
      end

    end
  end
end
