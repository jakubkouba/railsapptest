Rails.application.routes.draw do
  get 'health_check', to: 'health_check#show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
