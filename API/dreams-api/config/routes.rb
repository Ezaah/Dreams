Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    resources :measurements do
      collection do
        get 'last'
        get 'history'
      end
    end
    get 'alerts'
  end
  post '/sync' => 'api#sync'
end
