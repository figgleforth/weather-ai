# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../test_helper'


class ForecastTest < Minitest::Test
	def setup
		@forecast_with_sun_data = Forecast.new.tap do |forecast|
			forecast.sunrise = Time.zone.parse("2025-03-02 06:00:00")
			forecast.sunset  = Time.zone.parse("2025-03-02 18:00:00")
		end
		@forecast_without_sun_data = Forecast.new
	end

	def test_sunrise_formatting
		assert_equal " 6:00 AM", @forecast_with_sun_data.formatted_sunrise
		assert_nil @forecast_without_sun_data.formatted_sunrise
	end

	def test_sunset_formatting
		assert_equal " 6:00 PM", @forecast_with_sun_data.formatted_sunset
		assert_nil @forecast_without_sun_data.formatted_sunset
	end
end
