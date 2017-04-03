Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'weathers#index', as: '/'
  resource :weathers, only: [:index] do
    get 'current/:city_id', action: 'current', on: :collection
  end
end
