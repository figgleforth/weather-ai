class ForecastController < ApplicationController

	def index
		zipcode   = zipcode_param[:zipcode]
		@forecast = if zipcode
			ForecastHelper.forecast_for_zipcode zipcode
		else
			nil
		end

	rescue Faraday::ResourceNotFound => e
		Rails.logger.error "Faraday/OpenWeather Error: #{e.message}"
		flash[:alert] = "Faraday/OpenWeather Error: #{e.message}"
		redirect_to root_path
	end

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
		params.permit(:zipcode)
	end
end
