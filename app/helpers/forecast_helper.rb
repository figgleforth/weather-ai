# frozen_string_literal: true
require "open_weather"

module ForecastHelper
	API_KEY          = ENV.fetch('OPENWEATHER_API_KEY').freeze
	CACHE_EXPIRATION = 30.minutes.freeze

	# Given a zipcode, fetch the current weather for that location. Searches are cached for 30 minutes by the zipcode.
	# @param [String] zipcode
	# @return [Forecast, nil] Forecast object or nil if the OpenWeather API client fails
	def self.forecast_for_zipcode(zipcode)
		return nil unless zipcode.present?

		cache_id  = "WeatherHelper#forecast_for_zipcode(#{zipcode})"
		is_cached = Rails.cache.exist?(cache_id)

		data = Rails.cache.fetch(cache_id, expires_in: CACHE_EXPIRATION) do
			if (client = weather_client)
				client.current_weather(zip: zipcode)
			else
				nil
			end
		end

		return nil unless data

		# no need to type check the data object because #current_weather guarantees an OpenWeather::Models::City::Weather object unless an error occurred
		Forecast.new.tap do |forecast|
			forecast.cached         = is_cached
			forecast.location_name  = data.name
			forecast.temperature    = data.main.temp
			forecast.feels_like     = data.main.feels_like
			forecast.minimum        = data.main.temp_min
			forecast.maximum        = data.main.temp_max
			forecast.humidity       = data.main.humidity
			forecast.cloud_coverage = data.clouds.all
			forecast.sunrise        = data.sys.sunrise.in_time_zone(Rails.application.config.time_zone)
			forecast.sunset         = data.sys.sunset.in_time_zone(Rails.application.config.time_zone)
		end
	rescue StandardError => e
		# in prod, these errors and ones in LocationHelper are probably sent to Sentry, DataDog, etc
		nil
	end

	# @return [OpenWeather::Client, nil]
	def self.weather_client
		OpenWeather::Client.new(api_key: API_KEY, units: "imperial")
	rescue StandardError => e # based on OpenWeather source code, these errors are probably Faraday errors, but just in case I'm wrong I'll catch all
		nil
	end
end
