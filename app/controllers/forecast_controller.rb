class ForecastController < ApplicationController
	# this endpoint shows the weather search form and the weather details
	def index
		zipcode   = zipcode_param[:zipcode]
		@forecast = if zipcode
			ForecastHelper.forecast_for_zipcode zipcode.to_s
		else
			nil
		end

	rescue Faraday::ResourceNotFound => e
		Rails.logger.error "Faraday/OpenWeather Error: #{e.message}"
		flash[:alert] = "Faraday/OpenWeather Error: #{e.message}"
		redirect_to root_path
	end

	# this endpoint is posted to by the form found in the layout application.html.erb
	def get_forecast
		zipcode = LocationHelper.zipcode_for_address(address_param)

		if zipcode.nil?
			flash[:alert] = "Could not find a zipcode for the address '#{address_param}'"
			return redirect_to root_path
		end

		redirect_to root_path(zipcode: zipcode)

	rescue ActionController::ParameterMissing
		flash[:alert] = "Please provide a valid address search query"
		redirect_to root_path
	end

	private

	def address_param
		params.require(:address)
	end

	def zipcode_param
		params.permit(:zipcode) # this is not required because I chose to share the index page between the address search and the forecast
	end
end
