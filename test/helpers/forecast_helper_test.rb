# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../test_helper'


class ForecastHelperTest < Minitest::Test
	def setup
		@valid_zipcode   = "12345"
		@blank_zipcode   = ""
		@invalid_zipcode = "1243567890"
	end

	def test_with_valid_zipcode_returns_forecast
		assert_instance_of Forecast, ForecastHelper.forecast_for_zipcode(@valid_zipcode)
	end

	def test_with_invalid_zipcode_returns_nil
		Rails.cache.stub(:fetch, -> { raise StandardError }) do
			assert_nil ForecastHelper.forecast_for_zipcode @invalid_zipcode
		end
	end

	def test_with_blank_zipcode_returns_nil
		assert_nil ForecastHelper.forecast_for_zipcode @blank_zipcode
	end

	def test_dot_weather_client_returns_correct_type
		assert_instance_of OpenWeather::Client, ForecastHelper.weather_client
	end

	def test_dot_weather_client_returns_nil_when_error_raised
		simulated_error_raise = -> { raise StandardError }

		OpenWeather::Client.stub :new, simulated_error_raise do
			assert_nil ForecastHelper.weather_client
		end
	end
end
