Rails.application.routes.draw do
	root "forecast#index"
	post "/get_forecast", to: "forecast#get_forecast", as: :get_forecast
end
