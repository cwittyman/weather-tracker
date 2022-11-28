Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "forecasts#index"
  resources :locations
  resources :forecasts
  resources :hourlyforecasts, controller: 'hourly_forecasts'
  resources :dailyforecasts, controller: 'daily_forecasts'
  get 'hourlychart' => "hourly_forecasts#chart"
end
